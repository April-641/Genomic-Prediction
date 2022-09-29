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
      }
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
GP2_D_cross_geno <- read.table("../GGP3_produce/GGP3_D_produce/GP2_D_cross_geno.txt",header = F)
LY_dam_geno <- read.table("../LY_produce/LY_dam_geno.txt",header = F)
GP2_D_cross_pop <- read.table("../GGP3_produce/GGP3_D_produce/GP2_D_cross_pop.txt",header = T)
LY_dam_pop <- read.table("../LY_produce/LY_dam_pop.txt",header = T)
D_and_LY_geno <- cbind(GP2_D_cross_geno,LY_dam_geno) 
D_and_LY_pop <- rbind(GP2_D_cross_pop,LY_dam_pop) 
num_Pat_D <- 100
num_Mat_LY <- 10000
num_prog <- 10
mat_rat <- num_Mat_LY/num_Pat_D
input.map <- read.csv("../map.txt",sep = " ")
nmrk <- nrow(D_and_LY_geno)
nind <- ncol(D_and_LY_geno) / 2
pos.map <- check.map(input.map = input.map, num.marker = nmrk, len.block = 1e10)
blk.rg <- cal.blk(pos.map) 
pos.map[,7] <- 1 
recom.spot <- as.numeric(pos.map[blk.rg[, 1], 7]) 
D_s_gambank <- list()
for (j in 1:num_Pat_D) {  
  a <- 2*j-1
  b <- 2*j
  Ind <- D_and_LY_geno[,a:b]
  D_s_gambank[[j]] <- list() 
  for (i in 1:(mat_rat*num_prog)) {
    D_s_gambank[[j]][[i]] <- genotype(geno = Ind,
                                       blk.rg = blk.rg,
                                       recom.spot = recom.spot,
                                       range.hot = 4:6,  
                                       range.cold = 0, 
                                       verbose = T)
  }
}
library(dplyr)
D_s_gam <- bind_cols(D_s_gambank)
LY_d_gambank <- list()
for (j in (num_Pat_D+1):(num_Pat_D+num_Mat_LY)) {  
  a <- 2*j-1
  b <- 2*j
  Ind <- D_and_LY_geno[,a:b]
  LY_d_gambank[[j]] <- list() 
  for (i in 1:num_prog) {
    LY_d_gambank[[j]][[i]] <- genotype(geno = Ind,
                                           blk.rg = blk.rg,
                                           recom.spot = recom.spot,
                                           range.hot = 4:6,  
                                           range.cold = 0, 
                                           verbose = T)
  }
}
LY_d_gam <- bind_cols(LY_d_gambank)
D_and_LY_gam_geno <- cbind(D_s_gam,LY_d_gam) 
D_ind_pop <- D_and_LY_pop[rep(1:num_Pat_D,each=mat_rat*num_prog),]
LY_ind_pop <- D_and_LY_pop[rep((num_Pat_D+1):(num_Pat_D+num_Mat_LY),each=num_prog),]
D_and_LY_ind_pop <- rbind(D_ind_pop,LY_ind_pop)
D_and_LY_gam_pop <- D_and_LY_ind_pop
D_and_LY_gam_pop[,2] <- c(1:nrow(D_and_LY_gam_pop))  
library(tibble)
D_and_LY_ind_gam <- tibble(D_and_LY_ind_pop[,c(1,7,2)])
for (j in 1:num_Pat_D) {
  tmp <- paste(D_and_LY_pop$index[j],"-",sep = "")
  for (i in 1:(mat_rat*num_prog)) {
    D_and_LY_ind_gam[((j-1)*(mat_rat*num_prog)+i),4] <- paste(tmp,i,sep = "")
  }
}
for (j in (num_Pat_D+1):(num_Pat_D+num_Mat_LY)) {
  tmp <- paste(D_and_LY_pop$index[j],"-",sep = "")
  for (i in 1:num_prog) {
    D_and_LY_ind_gam[((j-(num_Pat_D+1))*num_prog+i+(mat_rat*num_prog*num_Pat_D)),4] <- paste(tmp,i,sep = "")
  }
}
D_and_LY_ind_gam[,5] <- D_and_LY_gam_pop[,2]
colnames(D_and_LY_ind_gam) <- c("gen","sex","ind","ind-gam","gam")
D_and_LY_mat <- list()
for (i in 1:num_Pat_D) {
  sir_ST <- mat_rat*num_prog*i-((mat_rat*num_prog)-1) 
  sir_EN <- mat_rat*num_prog*i 
  dam_ST <- mat_rat*num_prog*i-((mat_rat*num_prog)-1)+num_Pat_D*mat_rat*num_prog 
  dam_EN <- mat_rat*num_prog*i+num_Pat_D*mat_rat*num_prog 
  D_and_LY_mat[[i]] <- reproduces( pop1 = D_and_LY_gam_pop,
                                  pop1.geno.id = D_and_LY_gam_pop$index,  
                                  pop1.geno = D_and_LY_gam_geno,
                                  incols = 2, 
                                  ind.stay = list(sir=sir_ST:sir_EN, dam=dam_ST:dam_EN), 
                                  mtd.reprod = "randmate",
                                  num.prog = 1, 
                                  ratio = 0.5)
}
DLY_poplist <- list()
for(i in 1:num_Pat_D){
  DLY_poplist[[i]]<-D_and_LY_mat[[i]][[2]]
}
DLY_pop <- bind_rows(DLY_poplist)
DLY_pop[,2] <- c(1:nrow(DLY_pop))
DLY_pop[,3] <- DLY_pop[,2]
DLY_genolist <- list()
for(i in 1:num_Pat_D){
  DLY_genolist[[i]]<-D_and_LY_mat[[i]][[1]]
}
DLY_geno <- bind_cols(DLY_genolist)
save.image("DLY_produce.RData")
write.table(DLY_geno,file = "DLY_geno.txt",quote = F,sep = "\t",row.names = F,col.names = F)
write.table(DLY_pop,file = "DLY_pop.txt",quote = F,sep = "\t",row.names = F,col.names = T)
write.table(D_and_LY_ind_gam,file = "D_and_LY_ind_gam.txt",quote = F,sep = "\t",row.names = F,col.names = T)
