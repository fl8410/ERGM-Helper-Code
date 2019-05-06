Bulk.ERGM.Fit<-function(network=NULL,required.terms,optional.terms,AIC.thresh=NULL,numcores){
  #required.terms is a character vector of the ERGM terms that must be in the model (Ex:c("edges","mutual"))
  #optional.terms is a character vector of the ERGM terms that you think might be useful but aren't necessarily required in your model
  #This function assumes you have parallel processing ability
  #Network is a character vector of the network object 
  require(doParallel)
  require(foreach)
  require(gtools)
  registerDoParallel(cores=numcores)
  
  required.text.str<-do.call(paste,list(required.terms,collapse="+"))
  model.list<-lapply(1:length(optional.terms),function(i){
  combinations(n=length(optional.terms),r=i,v=optional.terms)})
  
  optional.vector<-unlist(lapply(1:length(optional.terms),
         function(i){
           unlist(lapply(1:(dim(model.list[[i]])[1]),
         function(j){do.call(
           paste,list(model.list[[i]][j,],collapse="+"))
         })
         )}
         ))
  
  models<-unlist(lapply(1:length(optional.vector),function(i){paste(c(required.text.str,optional.vector[i]),collapse="+")}))
  models<-unlist(lapply(1:length(models),function(i){paste(c(models[i],")"),collapse="")}))
  models<-unlist(lapply(1:length(models),function(i){paste(c("ergm(",network,"~",models[i]),collapse="")}))  
  model.fits<-foreach(k=1:length(models),.packages=c("ergm","ergm.userterms")) %dopar% try(eval(parse(text=models[k])),silent=TRUE)
  #bad.model.ind<-(unlist(lapply(model.fits,function(x){if(class(x)=="try-error"){Inf}else{AIC(x)}}))>AIC.thresh) #Optimization cannot continue,
  #good.model.fits<-model.fits[-c(which(bad.model.ind))]
  #return(good.model.fits)
  return(model.fits)
}



Models<-Bulk.ERGM.Fit(network="net1",required.terms=c("edges","inhomo2star('Sex')"),
              optional.terms=c("gwesp","nodematch('Sex')","mutual","localtriangle(lt)","gwdsp","gwidegree(1)","gwodegree","nodemix('Sex',c(1,4))"),
              AIC.thresh=1500,numcores=8)
