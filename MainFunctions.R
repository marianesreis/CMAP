#----
#Calculate the probabilities of observations given the class.
##This version (v1) uses the maximum likelihood approach for the Gaussian distribution.

#Author: Mariane S. Reis
#Modification date: 2023-10-09
#----


#Calculate the probability of the observations given a class. This code allows for the use of a mask to avoid the calculation on given areas (such as clouds)
#The mask should be zero in areas in which we desire to calculate the probability, and a desired index differnt than ero in areas we do not.

Probability_observation<-function(training, image, mask=(image[[1]]*0)){
  
  #Recupering the vectors with the name of the classes
  
  df<-data.frame(training[,1],training[,2])
  
  df<-unique(df)
  
  
  #Original index
  classes1<-df[,2]
  
  #Sequential index
  classes2<-df[,1]
  
  
  
  #Calculating the number of classes to which we need to derive the probabilities and the nu,ber of bands of the Image
  nclass<-length(classes2)
  nbands<-dim(image)[3]
  
  #Creating the empty vector for the determinant of the covariance matrix, mean vector, and inverse covariance matrix  mean and covariance values.
  cc<-vector(length=nclass)
  mm<-list(length=nclass)
  ii<-list(length=nclass)
  
  for (k in 1:nclass){
    temp<-training[which(training[,1]==classes2[k]),-c(1,2)]
    temp<-na.omit(temp)
    
    #Calculating the values of each element for each class
    cc[k]<-det(cov(temp)) 
    
    mm[[k]]<-as.numeric(sapply(temp,"mean"))
    
    #Garanting that all matrices can be inverted by adding a noise in those with zero varaince
    for (i in 1:nbands){
      if (as.numeric(sapply(temp,"var"))[i]==0) {
        temp[,i]<-temp[,i]+ runif(dim(temp)[1], min=0, max=10^-5)  
      }
    }
   
   
    ii[[k]]<-solve(cov(temp))
    
  }
  
  #Verifying areas to be computed
  id_mask<-which(mask[]==0)
  
  #Creating the data set for computation
  data <- as.matrix(image)[id_mask,]
  
  #Computing the probabilities using a Gaussian model
  const <- 2*pi^(nbands/2)
  rule<-do.call(cbind, lapply(1L:nclass, function(k) {
    m <- sweep(data, 2L, mm[[k]])
    1/(const*cc[k]^(1/2))* exp(-1/2 * rowSums((m %*% ii[[k]]) * m))
  }))
  
  
  #Recuperating the original index of classes
  ind_class<-sort(unique(classes1))
  
  #calculating the maximum value of subclasses as the represnetative of each class
  for(c in 1:length(ind_class)){
    
    rule_temp<-rule[, which(classes1==ind_class[c])]    
    if(is.null(dim(rule_temp))==FALSE){
      rule_temp<-apply(rule_temp, 1, max)} 
    
    if (c==1) {rule2<-rule_temp} else {rule2<-cbind(rule2,rule_temp)}  
    
  }  
  
  colnames(rule2)<-(ind_class) 
  
  #Creating a raster with the same size than the image
  imgt<-subset(image,1)
  
  
  #Areas under the mask will receive a value equal to 1/#classes
  imgt[]<-1/length(ind_class)
  
  #Computed areas receives the maximum value calculated for each set of subclasses
  for (k in 1:max(ind_class)){
    col<-which(as.numeric(colnames(rule2))==k)
    
    if(length(col)==1){imgt[id_mask]<-rule2[,col]} else {imgt[id_mask]<-0}
    
    if(k==1){imgR<-imgt} else {imgR<-c(imgR,imgt)}    
    
  }
   return(imgR)
}

#Calculates CMAP in R memory.
CMAP_memory<-function(probs.list, Ps, mask=(probs.list[[1]]*0)){
  
  #Assessing some values
  nimgs<-length(probs.list)
  
  nclasses<-vector(length=nimgs)      
  
  id_mask<-which(mask[]==0)
  
  #Constructing a data set with all the probabilities values
  for (i in 1:nimgs){
    temp<-probs.list[[i]]
    nclasses[i]<-dim(temp)[3]
    temp<-as.data.frame(temp)[id_mask,]
    if (i==1){data=temp} else {data=cbind(data,temp)}  
  }


  #Creating a matrix to receive the classification results 
  class<-matrix(nrow=dim(data)[1],ncol=nimgs)

  #Creating a vector to receive the maximum value of probabilities calculates so far
  v.max<-vector(length=dim(data)[1])
  # and one to receive the value of the probability of the current one
  v.t<-vector(length=dim(data)[1])
  
  
  #Assigning arbitrary initial values
  class[,]<-0
  v.max[]<--100
  
#Looking for the maximum in all possible trajectories describe din each row of Ps    
  for (v in 1:dim(Ps)[1]){

    #Retrieving the trajectory
    seq<-as.numeric(Ps[v,1:nimgs])
    
    #Getting the probabilities of observation given the class of the class of first date
    s1=as.numeric(seq[1])
    v.t[]<-data[,s1]
    
    #Multiplying by the value on other dates
    for (s in 2:length(seq)){
      s1=as.numeric(seq[s]+sum(nclasses[1:(s-1)]))
      v.t=v.t*data[,s1]
      
    }
    
    #Multiplying by the value of Ps
    v.t=v.t*(Ps[v,1+nimgs]) 
    
    
    #We now need to see if this value is higher than the previous maximum and attribute the correct classes of the analysed trajectory if this is the new maximum
    for (i in 1:length(seq)){
      
      ind<-which(v.t>v.max)
      
      class[ind,i]<-seq[i]    
      
    }    
    
    #We substitute the values in case a new maximum has been achieved
    v.max[ind]<-v.t[ind]

  }
  
  
  #Creating a raster file to receive the classification results
  c.r<-mask
  
  #Transforming the matrix into a multi-layer raster (each layer is one land cover result)
  for (i in 1:nimgs){
    c.r[id_mask]<-class[,i]
    if (i==1){CMAP<-c.r} else {CMAP<-c(CMAP,c.r)}

  }
  
  return(CMAP)
}


#Calculates CMAP using the files saved in an external folder.
CMAP_saved<-function(probs.path, Ps, mask=(rast(probs.path[1])[[1]]*0), prefix,suffix=c(1:length(probs.path))){
  
  #Assessing some values
  nimgs<-length(probs.list)
  
  nclasses<-vector(length=nimgs)      
  
  id_mask<-which(mask[]==0)

  
  #Constructing a data set with all the probabilities values
  for (i in 1:nimgs){
    temp<-rast(probs.path[i])
    nclasses[i]<-dim(temp)[3]
    temp<-as.data.frame(temp)[id_mask,]
    if (i==1){data=temp} else {data=cbind(data,temp)}  
  }
  
  
  #Creating a matrix to receive the classification results 
  class<-matrix(nrow=dim(data)[1],ncol=nimgs)
  
  #Creating a vector to receive the maximum value of probabilities calculates so far
  v.max<-vector(length=dim(data)[1])
  # and one to receive the value of the probability of the current one
  v.t<-vector(length=dim(data)[1])
  
  
  #Assigning arbitrary initial values
  class[,]<-0
  v.max[]<--100
  
  #Looking for the maximum in all possible trajectories describe din each row of Ps    
  for (v in 1:dim(Ps)[1]){
    
    #Retrieving the trajectory
    seq<-as.numeric(Ps[v,1:nimgs])
    
    #Getting the probabilities of observation given the class of the class of first date
    s1=as.numeric(seq[1])
    v.t[]<-data[,s1]
    
    #Multiplying by the value on other dates
    for (s in 2:length(seq)){
      s1=as.numeric(seq[s]+sum(nclasses[1:(s-1)]))
      v.t=v.t*data[,s1]
      
    }
    
    #Multiplying by the value of Ps
    v.t=v.t*(Ps[v,1+nimgs]) 
    
    
    #We now need to see if this value is higher than the previous maximum and attribute the correct classes of the analysed trajectory if this is the new maximum
    for (i in 1:length(seq)){
      
      ind<-which(v.t>v.max)
      
      class[ind,i]<-seq[i]    
      
    }    
    
    #We substitute the values in case a new maximum has been achieved
    v.max[ind]<-v.t[ind]
    
  }
  
  
  #Creating a raster file to receive the classification results
  c.r<-mask
  
  #Transforming the matrix into a multi-layer raster and saiving it (i will save one .tif for each year)
  for (i in 1:nimgs){
    c.r[id_mask]<-class[,i]
    writeRaster(c.r,paste0(prefix, "_", suffix[i],".tif"))
    
  }

}



