rm(list = ls())
check.map <- function(input.map = NULL, num.marker = NULL, len.block = 5e7) {
  if (is.null(input.map)) 
    stop("Please input a map file!")
  if (num.marker != nrow(input.map))
    stop("The number of markers should be equal between genotype file and map file!")
  if (!is.data.frame(input.map))
    input.map <- is.data.frame(input.map)
  chrs <- unique(input.map[, 2])
  pos.mrk <- as.numeric(input.map[, 3])
  nc.map <- ncol(input.map)
  if (nc.map == 7) {
    map <- input.map
  } else {
    temp.recom <- lapply(chrs, function(chr) {
      f <- input.map[, 2] == chr
      if (nc.map == 5) {
        block <- (pos.mrk[f] %/% len.block) + 1
      } else if (nc.map == 6) {
        block <- input.map[f, 6]
      } else {
        stop("Please check the format of map!")
      }
      ub <- unique(block)
      tb <- table(block)
      if (tb[length(tb)] < 0.5*mean(tb[1:(length(tb)-1)])) {
        tb[length(ub)-1] <- tb[length(tb)-1] + tb[length(tb)]
        tb <- tb[-length(tb)]
        block[block == ub[length(ub)]] <- ub[length(ub)-1]
      }
      s1 <- length(tb)
      s2 <- s1 %/% 3
      r1 <- rep(c(1, 0, 1), c(s2, (s1-2*s2), s2))
      recom <- rep(r1, tb)
      t <- cbind(block, recom)
      return(t)
    })
    recom.spot <- do.call(rbind, temp.recom)
    map <- cbind(input.map[, 1:5], recom.spot)
  }
  return(map)
}
cal.blk <- function(pos.map) {
  chr.uni <- unique(pos.map[, 2])
  chr.tab <- sapply(1:length(chr.uni), function(chr) { return(sum(pos.map[, 2] == chr.uni[chr])) })
  chr.ed <- sapply(1:length(chr.tab), function(chr) { return(sum(chr.tab[1:chr])) })
  chr.op <- chr.ed - chr.tab + 1
  blk.rg <- do.call(rbind, lapply(1:length(chr.tab), function(chr) {
    blk.tab <- table(as.numeric(pos.map[chr.op[chr]:chr.ed[chr], 6]))
    blk.ed <- sapply(1:length(blk.tab), function(blk) { return(sum(blk.tab[1:blk])) })
    blk.op <- blk.ed - blk.tab + 1
    blk.rg <- cbind(blk.op, blk.ed)
    return(blk.rg + chr.op[chr] - 1)
  }))
  return(blk.rg)
}
genotype <-
  function(rawgeno = NULL,
           geno = NULL,
           incols = 2, 
           num.marker = NULL,
           num.ind = NULL,
           prob = c(0.5, 0.5),
           blk.rg = NULL,
           recom.spot = NULL,
           range.hot = 4:6,
           range.cold = 1:5,
           rate.mut = 1e-8, 
           verbose = TRUE) {
    if (is.null(rawgeno) & is.null(geno) & is.null(num.marker) & is.null(num.ind)) {
      stop("Please input information of genotype!")
    }
    if (!is.null(rawgeno)) {
      logging.log(" Input outer genotype matrix...\n", verbose = verbose)
      if (!is.matrix(rawgeno)) {
        rawgeno <- as.matrix(rawgeno)
      }
      outgeno <- rawgeno
    } else if (!is.null(num.marker) && !is.null(num.ind)){
      logging.log(" Establish genotype matrix of base-population...\n", verbose = verbose)
      if (incols == 2) {
        codes <- c(0, 1)
      } else if (incols == 1) {
        codes <- c(0, 1, 2)
        if (!is.null(prob))
          prob <- c(prob[1]^2, 2*prob[1]*prob[2], prob[2]^2)
      } else {
        stop("incols should only be 1 or 2!")
      }
      outgeno <- matrix(sample(codes, num.marker*num.ind*incols, prob = prob, replace = TRUE), num.marker, incols*num.ind)
    } else if (!is.null(geno) & !is.null(recom.spot) & incols == 2) {
      logging.log(" Chromosome exchange and mutation on genotype matrix...\n", verbose = verbose)
      num.marker <- nrow(geno)
      num.ind <- ncol(geno) / incols
      geno.swap <- function(ind) {
        swap.rg <- do.call(rbind, lapply(1:nrow(blk.rg), function(blk) {
          num.swap <- ifelse(recom.spot[blk], sample(range.hot, 1), sample(range.cold, 1))
          spot.swap.raw <- sort(sample((blk.rg[blk, 1]+1):(blk.rg[blk, 2]-1), num.swap, replace = TRUE))
          spot.swap <- c(blk.rg[blk, 1], spot.swap.raw)
          flag1.swap <- !(num.swap %% 2 == 0)
          flag.swap <- rep(flag1.swap, (num.swap+1))
          flag.swap[seq(2, (num.swap+1), 2)] <- !flag1.swap
          flag.swap.raw <- flag.swap[-length(flag.swap)]
          swap.op <- spot.swap[flag.swap]
          swap.ed <- spot.swap.raw[flag.swap.raw]
          return(cbind(swap.op, swap.ed))
        }))
        geno.t <- geno[, (2*ind-1):(2*ind)]
        for (swap in 1:nrow(swap.rg)) {
          op <- swap.rg[swap, 1]
          ed <- swap.rg[swap, 2]
          geno.t[op:ed, ] <- geno.t[op:ed, 2:1]
        }
        return(geno.t)
      }# end geno.swap.ind
      outgeno <- do.call(cbind, lapply(1:num.ind, geno.swap))
      spot.total <- num.marker * incols * num.ind
      num.mut <- ceiling(spot.total * rate.mut)
      row.mut <- sample(1:num.marker, num.mut)
      col.mut <- sample(1:(incols*num.ind), num.mut)
      for (i in 1:length(row.mut)) {
        if (geno[row.mut[i], col.mut[i]] == 1) {
          outgeno[row.mut[i], col.mut[i]] <- 0
        } else {
          outgeno[row.mut[i], col.mut[i]] <- 1
        }
      }
    } else if ((!is.null(geno) & incols == 1)|(!is.null(geno) & is.null(recom.spot))) {
      logging.log(" Mutation on genotype matrix...\n", verbose = verbose)
      num.marker <- nrow(geno)
      num.ind <- ncol(geno) / incols
      outgeno <- geno
      spot.total <- num.marker * incols * num.ind
      num.mut <- ceiling(spot.total * rate.mut)
      row.mut <- sample(1:num.marker, num.mut)
      col.mut <- sample(1:(incols*num.ind), num.mut)
      for (i in 1:length(row.mut)) {
        if (geno[row.mut[i], col.mut[i]] == 1) {
          outgeno[row.mut[i], col.mut[i]] <- 0
        } else {
          outgeno[row.mut[i], col.mut[i]] <- 1
        }
      }
    } else {
      stop("Please input the correct genotype matrix!")
    }
    return(outgeno)
  }
logging.log <- function(..., file = NULL, sep = " ", fill = FALSE, labels = NULL, verbose = TRUE) {
  if (verbose) {
    cat(..., sep = sep, fill = fill, labels = labels)
  }
  if (is.null(file)) {
    try(file <- get("logging.file", envir = package.env), silent = TRUE)
  }
  if (!is.null(file)) {
    cat(..., file = file, sep = sep, fill = fill, labels = labels, append = TRUE)
  }
}
reproduces <-
  function(pop1 = NULL,
           pop2 = NULL,
           pop1.geno.id = NULL,
           pop2.geno.id = NULL,
           pop1.geno = NULL,
           pop2.geno = NULL,
           incols = 2, 
           ind.stay = NULL,
           mtd.reprod = "randmate",
           num.prog = 2,
           ratio = 0.5) {
    if (!is.null(pop1.geno.id) & !is.null(pop1.geno)) {
      if (length(pop1.geno.id)*incols != ncol(pop1.geno)) 
        stop("Genotype ID should match genotype matrix in the first population!")
    }
    if (!is.null(pop2.geno.id) & !is.null(pop2.geno)) {
      if (length(pop2.geno.id)*incols != ncol(pop2.geno)) 
        stop("Genotype ID should match genotype matrix in the second population!")
    }
    if (mtd.reprod == "clone") {
      pop <- mate.clone(pop1, pop1.geno.id, pop1.geno, incols, ind.stay, num.prog)
    } else if (mtd.reprod == "dh") {
      pop <- mate.dh(pop1, pop1.geno.id, pop1.geno, incols, ind.stay, num.prog)
    } else if (mtd.reprod == "selfpol") {
      pop <- mate.selfpol(pop1, pop1.geno.id, pop1.geno, incols, ind.stay, num.prog, ratio)
    } else if (mtd.reprod == "singcro") {
      pop <- mate.singcro(pop1, pop2, pop1.geno.id, pop2.geno.id, pop1.geno, pop2.geno, incols, ind.stay, num.prog, ratio)
    } else if (mtd.reprod == "randmate") {
      pop <- mate.randmate(pop1, pop1.geno.id, pop1.geno, incols, ind.stay, num.prog, ratio)
    } else if (mtd.reprod == "randexself") {
      pop <- mate.randexself(pop1, pop1.geno.id, pop1.geno, incols, ind.stay, num.prog, ratio)
    } else {
      stop("Please input a right option within mtd.reprod!")
    }
    return(pop)
  }
mate <- function(pop.geno, incols = 2, index.sir, index.dam) {
  num.marker <- nrow(pop.geno)
  pop.geno.curr <- matrix(3, nrow = num.marker, ncol = length(index.dam) * incols)
  if (incols == 2) {
    s1 <- sample(c(0, 1), size = length(index.dam), replace=TRUE)
    s2 <- sample(c(0, 1), size = length(index.dam), replace=TRUE)
    gmt.sir <- index.sir * 2 - s1
    gmt.dam <- index.dam * 2 - s2
    gmt.comb <- c(gmt.sir, gmt.dam)
    gmt.comb[seq(1, length(gmt.comb), 2)] <- gmt.sir
    gmt.comb[seq(2, length(gmt.comb), 2)] <- gmt.dam
    pop.geno.curr <- pop.geno[, gmt.comb]
  } else {
    num.block <- 100
    len.block <- num.marker %/% num.block
    tail.block <- num.marker %% num.block + len.block
    num.inblock <- c(rep(len.block, (num.block-1)), tail.block)
    accum.block <- Reduce("+", num.inblock, accumulate = TRUE)
    for (i in 1:100) {
      ed <- accum.block[i]
      op <- ed - num.inblock[i] + 1
      judpar <- sample(c(0, 1), length(index.dam), replace = TRUE)
      index.prog <- judpar * index.sir + (1-judpar) * index.dam
      pop.geno.curr[op:ed, ] <- pop.geno[op:ed, index.prog]
    }
  }
  return(pop.geno.curr)
}
mate.randmate <- function(pop1, pop1.geno.id, pop1.geno, incols = 2, ind.stay, num.prog, ratio) {
  ped.sir <- ind.stay$sir
  ped.dam <- ind.stay$dam
  num.dam <- length(ped.dam)
  if (length(ped.sir) == 1) ped.sir <- rep(ped.sir, 2)
  ped.sir <- sample(ped.sir, size = num.dam, replace = FALSE)
  ped.sir <- rep(ped.sir, each = num.prog)
  ped.dam <- rep(ped.dam, each = num.prog)
  num.ind <- length(ped.dam)
  if (floor(num.ind * ratio) != num.ind * ratio) {
    stop("The product of population size and ratio should be a integer!")
  }
  index.sir <- match(ped.sir, pop1.geno.id)
  index.dam <- match(ped.dam, pop1.geno.id)
  pop.geno.curr <- mate(pop.geno = pop1.geno, incols = incols, index.sir = index.sir, index.dam = index.dam)
  if (all(pop1$sex == 0)) {
    sex <- rep(0, num.prog*num.dam)
  } else {
    sex <- rep(2, num.ind)
    for (i in 1:(num.ind/10)) {
      int_ST <- 10*i-9
      int_EN <- 10*i
      p <- sample(int_ST:int_EN,5)
      sex[c(p)] <- 1
    }
#    sex[sample(1:num.ind, num.ind * ratio)] <- 1
  }
  index <- seq(pop1$index[length(pop1$index)]+1, length.out = num.ind)
  fam.temp <- getfam(ped.sir, ped.dam, pop1$fam[length(pop1$fam)]+1, "pm")
  gen <- rep(pop1$gen[1]+1, num.ind)
  pop.curr <- tibble(gen = gen, index = index, fam = fam.temp[, 1], infam = fam.temp[, 2], sir = ped.sir, dam = ped.dam, sex = sex)
  list.randmate <- list(geno = pop.geno.curr, pop = pop.curr)
  return(list.randmate)
}
getfam <- function(sir, dam, fam.op, mode = c("pat", "mat", "pm")) {
  fam <- rep(0, length(sir))
  infam <- rep(0, length(sir))
  if (mode == "pat") {
    uni.sir <- unique(sir)
    for (i in 1:length(uni.sir)) {
      flag <- sir == uni.sir[i]
      fam[flag] <- fam.op + i - 1
      infam[flag] <- 1:sum(flag)
    }
  } else if (mode == "mat") {
    uni.dam <- unique(dam)
    for (i in 1:length(uni.dam)) {
      flag <- dam == uni.dam[i]
      fam[flag] <- fam.op + i - 1
      infam[flag] <- 1:sum(flag)
    }
  } else if (mode == "pm") {
    uni.sd <- unique(cbind(sir, dam))
    for (i in 1:nrow(uni.sd)) {
      flag1 <- sir == uni.sd[i, 1]
      flag2 <- dam == uni.sd[i, 2]
      flag <- flag1 & flag2
      fam[flag] <- fam.op + i - 1
      infam[flag] <- 1:sum(flag)
    }
  } else {
    stop("Please input right mode!")
  }
  return(cbind(fam, infam))
}
setwd(getwd())
#library(simer)
GP1_L_cross_geno <- read.table("../GGP2_produce/GGP2_L_produce/GP1_L_cross_geno.txt",header = F)
GP1_Y_cross_geno <- read.table("../GGP2_produce/GGP2_Y_produce/GP1_Y_cross_geno.txt",header = F)
GP1_L_cross_pop <- read.table("../GGP2_produce/GGP2_L_produce/GP1_L_cross_pop.txt",header = T)
GP1_Y_cross_pop <- read.table("../GGP2_produce/GGP2_Y_produce/GP1_Y_cross_pop.txt",header = T)
L_and_Y_geno <- cbind(GP1_L_cross_geno,GP1_Y_cross_geno)
L_and_Y_pop <- rbind(GP1_L_cross_pop,GP1_Y_cross_pop)
num_Pat_L <- 100
num_Mat_Y <- 2000
num_prog <- 10
mat_rat <- num_Mat_Y/num_Pat_L
input.map <- read.csv("../map.txt",sep = " ")
nmrk <- nrow(L_and_Y_geno)
nind <- ncol(L_and_Y_geno) / 2
# set block information and recombination information
pos.map <- check.map(input.map = input.map, num.marker = nmrk, len.block = 1e10)#add block id and combination information to genotypic map
#按照input.map文件中的物理位置来划分block，向量的长度代表把整个基因组分成多少区域，以每条染色体为一个单位，按5e7的长度进行划分，例如chr1上物理位置为0～5e7的snp为block1，5e7~2*5e7的snp为block2。
#到chr2时，也重新从block1开始划分，block一列有多个1，2，正是因为每条染色体会重新划分block。
#原来采用5e7的长度进行block划分时，总共会有51个block。但是后来老师建议直接将每条染色体作为一个block，于是我把block的长度设置的很大，这样的话由于
#每条染色体上的最后一个标记的物理位置都是小于block的长度的，到下一条染色体会重新开始划分，于是得到19个block
blk.rg <- cal.blk(pos.map)
pos.map[,7] <- 1 
#原本，在一条染色体上存在多个block时，pos.map文件的第七列recom设定规则为：染色体末端的block设为1，染色体中部的block设为0，当然你可以自己设定
#因为按染色体改成了19个block，所以每个block我都要设为重组热点，因为每个block的起始SNP(在这里指：第x条染色体上的第1个标记)在pos.map文件的第七列的
#recom值(0/1)会作为该block为重组热点还是冷点的判断依据，因此我干脆把所有的recom值都改成1了。
recom.spot <- as.numeric(pos.map[blk.rg[, 1], 7])
#recom.spot是重组热冷点的分布状况，1是重组热点，在这个区域内会发生较多的重组事件，
#0是重组冷点，表示该区域会发生较少的重组事件，并不是没有
#哪怕以上的参数都是固定的，每次运行下列的代码产生的基因型矩阵都不一样
#制作公畜的配子库。每头公畜产生mat_rat*num_prog对配子
L_s_gambank <- list()
for (j in 1:num_Pat_L) {  
  a <- 2*j-1
  b <- 2*j
  Ind <- L_and_Y_geno[,a:b]
  L_s_gambank[[j]] <- list() 
  for (i in 1:(mat_rat*num_prog)) {
    L_s_gambank[[j]][[i]] <- genotype(geno = Ind,
                                       blk.rg = blk.rg,
                                       recom.spot = recom.spot,
                                       range.hot = 4:6, 
                                       range.cold = 0,
                                       verbose = T)
  }
}
#range.hot表示重组热点内发生重组事件的个数，也就是recom.spot里面1对应的区域，我们一般认为越靠近染色体末端重组事件越频繁，recom.spot的默认值就是这样的。
#同理，recom.spot里面0元素对应的就是range.cold，它要比range.hot小，到底发生几次重组会从该范围内随机挑选
library(dplyr)
L_s_gam <- bind_cols(L_s_gambank)
Y_d_gambank <- list()
for (j in (num_Pat_L+1):(num_Pat_L+num_Mat_Y)) {  
  a <- 2*j-1
  b <- 2*j
  Ind <- L_and_Y_geno[,a:b]
  Y_d_gambank[[j]] <- list() 
  for (i in 1:num_prog) {
    Y_d_gambank[[j]][[i]] <- genotype(geno = Ind,
                                           blk.rg = blk.rg,
                                           recom.spot = recom.spot,
                                           range.hot = 4:6, 
                                           range.cold = 0,
                                           verbose = T)
  }
}
#range.hot表示重组热点内发生重组事件的个数，也就是recom.spot里面1对应的区域，我们一般认为越靠近染色体末端重组事件越频繁，recom.spot的默认值就是这样的。
#同理，recom.spot里面0元素对应的就是range.cold，它要比range.hot小，到底发生几次重组会从该范围内随机挑选
Y_d_gam <- bind_cols(Y_d_gambank)
L_and_Y_gam_geno <- cbind(L_s_gam,Y_d_gam)
#制作gam的pop文件
L_ind_pop <- L_and_Y_pop[rep(1:num_Pat_L,each=mat_rat*num_prog),]
Y_ind_pop <- L_and_Y_pop[rep((num_Pat_L+1):(num_Pat_L+num_Mat_Y),each=num_prog),]
L_and_Y_ind_pop <- rbind(L_ind_pop,Y_ind_pop)
L_and_Y_gam_pop <- L_and_Y_ind_pop
L_and_Y_gam_pop[,2] <- c(1:nrow(L_and_Y_gam_pop)) 
#制作ind_gam文件,因为reproduce函数只识别从1顺序排列的个体号index，而我的策略是把配子看作个体
#gam_pop文件中的index号实际上是配子号，所以另外制作一个ind_gam文件，标明了配子的个体来源。
#ind_gam文件的主要用途：查找除GGP1以外（GGP1的亲本未知）的个体的亲本来源，因为他们的pop文件中sir和dam两栏的数字不是个体号而是配子号。根据配子号可以去其亲本的ind_gam文件中得到对应的个体号。
library(tibble)
L_and_Y_ind_gam <- tibble(L_and_Y_ind_pop[,c(1,7,2)])
for (j in 1:num_Pat_L) {
  tmp <- paste(L_and_Y_pop$index[j],"-",sep = "")
  for (i in 1:(mat_rat*num_prog)) {
    L_and_Y_ind_gam[((j-1)*(mat_rat*num_prog)+i),4] <- paste(tmp,i,sep = "")
  }
}
for (j in (num_Pat_L+1):(num_Pat_L+num_Mat_Y)) {
  tmp <- paste(L_and_Y_pop$index[j],"-",sep = "")
  for (i in 1:num_prog) {
    L_and_Y_ind_gam[((j-(num_Pat_L+1))*num_prog+i+(mat_rat*num_prog*num_Pat_L)),4] <- paste(tmp,i,sep = "")
  }
}
L_and_Y_ind_gam[,5] <- L_and_Y_gam_pop[,2]
colnames(L_and_Y_ind_gam) <- c("gen","sex","ind","ind-gam","gam")
#进入交配体系，每头公猪配mat_rate头母猪,每头公猪单独进入一个循环。
L_and_Y_mat <- list()
for (i in 1:num_Pat_L) {
  sir_ST <- mat_rat*num_prog*i-((mat_rat*num_prog)-1)
  sir_EN <- mat_rat*num_prog*i
  dam_ST <- mat_rat*num_prog*i-((mat_rat*num_prog)-1)+num_Pat_L*mat_rat*num_prog
  dam_EN <- mat_rat*num_prog*i+num_Pat_L*mat_rat*num_prog
  L_and_Y_mat[[i]] <- reproduces( pop1 = L_and_Y_gam_pop,
                                  pop1.geno.id = L_and_Y_gam_pop$index, 
                                  pop1.geno = L_and_Y_gam_geno,
                                  incols = 2,
                                  ind.stay = list(sir=sir_ST:sir_EN, dam=dam_ST:dam_EN),
                                  mtd.reprod = "randmate",
                                  num.prog = 1,
                                  ratio = 0.5)
}
LY_poplist <- list()
for(i in 1:num_Pat_L){
  LY_poplist[[i]]<-L_and_Y_mat[[i]][[2]]
}
LY_pop <- bind_rows(LY_poplist)
LY_pop[,2] <- c(1:nrow(LY_pop))
LY_pop[,3] <- LY_pop[,2]
LY_genolist <- list()
for(i in 1:num_Pat_L){
  LY_genolist[[i]]<-L_and_Y_mat[[i]][[1]]
}
LY_geno <- bind_cols(LY_genolist)
save.image("LY_produce.RData")
write.table(LY_geno,file = "LY_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(LY_pop,file = "LY_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(L_and_Y_ind_gam,file = "L_and_Y_ind_gam.txt",quote = F,sep = "\t",row.names = F,col.names = T)
