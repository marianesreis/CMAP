###Auxiliary Functions###

#----
#Auxiliary functions to modify data for use within the CMAP algorithm (v1),
#Author: Mariane S. Reis
#Modification date: 2023-10-09
#----

#Construct the labeled samples dataset
## In which base is the vector containing the path to to the base images (observations) and
## samples is the vector containing the path to the labeled samples. Both must be written following the same order (e.g. image1/Samples1, image 2/samples2, etc.)

Construct_Training<-function(base,samples){

nref <- length(base)

ind_t<-vector(length=nref+1)
ind_t[1]<-0


#In cases in which we have more than one Base Image, it is necessary to change the indexes so we do not merge samples from different images.
classes1<-c() #original labels
classes2<-c() #new labels



for (i in 1:nref){
  
  #Looking into each pair of Base image and Labeled Samples
  
  base_i<-rast(base[i])
  samples_i<-rast(samples[i])
  
  nbands<-dim(base_i)[3] #Calculating the number of layers in the Image Base file. Must be the same for all images
  
  #Stacking the data and constructing a data frame
  data_a<-c(samples_i,base_i)
  data_a<-as.data.frame(data_a)
  
  
  #Removing NA and unlabeled pixels
  data_a<-na.omit(data_a)
  data_a<- data_a[which(data_a[,1]!=0),]
  
  #Identifying unique labels (indexes used for each class)
  
  ind_t[i+1]<-length(unique(data_a[,1]))
  
  #Generating some identifying vectors for later
  new_id<-data_a[,1]
  colnames(data_a)<-c("original_id", paste0("Layer_", c(1:nbands)))
  
  classes_id1<-sort(unique(data_a[,1]))
  classes_id2<-sum(ind_t[1:i])+(1:length(classes_id1))
  
  classes1<-append(classes1,classes_id1)
  classes2<-append(classes2,classes_id2)
  
  #Changing the labels of the classes to allow for the identification of subclasses
    for (k in 1:length(classes_id1)){
    new_id[which(data_a[,1]==classes_id1[k])]<-classes_id2[k]
  }

  #Constructing the data.frame
  data_a<-cbind(new_id, data_a)
  
  #Binding the data.frame of all Base Images
  if (i==1) {data<-data_a} else {data<-rbind(data,data_a)}
  
}

return(data)
  
}    



#Compute the Maximum Likelihood Classification of a data set using the calculated probabilities of observation given the classes
MLC<-function(probs){
  
  imgt<-subset(probs,1)
  df<-as.data.frame(probs)
  c1<-max.col(df,ties.method="first")
  imgt[]<-c1[]
  
  return(imgt)
  
}

#Multiplies the matrices depicting the likelihood of transitions. Matrices is a vector containing the paths for the transition matrices. Must be ordered in time.

Traj_probs<-function(matrices){
  
  #Assessing some necessary values
  nt<-length(matrices)
  nclass<-vector(length=(nt+1))
  classes<-list(length=nt+1)
  
  
  for (z in 1:nt){
    
    t1<-read.table(matrices[z], sep=";", h=F)  
    
    if(z==1) {nclass[1]<-dim(t1)[1]; classes[[1]]<-c(1:dim(t1)[1])}
    
    nclass[(z+1)]<-dim(t1)[2]
    classes[[z+1]]<-c(1:dim(t1)[2])
    
  }
  
  tab<-expand.grid(classes[])
  

  Pt<-vector(length=dim(tab)[1])
  
  for (z in 1:nt){
    
    t1<-read.table(matrices[z], sep=";", h=F)  
    
    for (l in 1:dim(t1)[1]){
      
      for (c in 1:dim(t1)[2]){
        
        Pt[which(tab[,z]==l&tab[,z+1]==c)]<-t1[l,c]      
        
      }
    }  
    
    tab<-cbind(tab,Pt)
  }
  
  
  if(nt>1){
    
    temp<-tab[,((nt+2):dim(tab)[2])]
    
    Ps<-apply(temp, 1, prod)
    
    tab<-cbind(tab,Ps)
    
    cf<-dim(tab)[2]
    
    tab<-tab[which(tab[,cf]!=0),-c((nt+2):(cf-1))]}
  
  return(tab)
  
}


#Normalizes the sum of the probabilities of each date (so the sum of probabilities of observation considering all the classes equal to 1).
Norm_probs<-function(probs){
  
  #Assessing the number os classes
  nclass<-dim(probs)[3]
  
  probs.sum<-sum(probs)
  
  id<-which(probs.sum[]==0)
  probs.sum[id]<-1

  for (k in 1:nclass){
    probs[[k]]<-probs[[k]]/probs.sum
  }
   return(probs)
}

#Returns a binary a raster layer with one for areas in which the sum of probabilities is zero, and zero otherwise
#This layer follows the same pattern of any mask to be used within the main functions (in which zero indicates areas that should be classified.)

Verify_nulls<-function(probs){
 
  probs.sum<-sum(probs)
  
  id<-which(probs.sum[]==0)
  mask<-probs.sum*0
  mask[id]<-1
 
  return(mask)
}
