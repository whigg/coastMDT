#' Iterative box filter
#'
#' The function \code{iterativeAveSmoother} is a simple average filter applied nit number of times. The size of the filter in the E-W direction is scaled according to the latitude.   
#' @param dat An object as returned by the function 'getSubGrid', which includes a list containing  a matrix g[lon,lat], a vector lon (longitudes) and a vector lat (latitudes). The matrix dat$g[lon,lat] containes the values to be filtered.
#' @param mask An object as returned by the function 'getSubGrid', which includes a list containing  a matrix g[lon,lat], a vector lon (longitudes) and a vector lat (latitudes). mask$g is a Matrix[lon,lat] representing the land mask, where land=0 and water=1.
#' @param land Matrix[lon,lat] containing land values
#' @param radius Filter radius. Default is radius=0.15/0.83
#' @param nit Number of iterations of the box filter. Default is nit=10
#' @param res Grid spacing of the matrix dat. Default is dlat=0.125
#' @param countMat A matrix where each element represent the number of times each element i the data matrix "dat" should be counted.
#' @return  List with the elements;  matrix[lon,lat] g (grid), vector lon (longitudes), vector lat (latitudes).    
#' @details ...
iterativeAveSmootherBoot<-function(dat,mask,land, radius=0.15/0.83,nit=10,res=0.125, countMat=NULL){
    grid<-t(dat$g)
    mask<-t(mask$g)
    land<-t(land$g)
    countMatt<-t(countMat)
    idland<-which(mask==0,arr.ind=TRUE)
    grid[idland]<-land[idland]
    sigmau<-radius/res/sqrt(2)
    nr<-nrow(grid)
    nc<-ncol(grid)
    nfiltNS<-floor(sigmau)
    for (i in 1:nit){
       for(i in (nfiltNS+1):(nr-(nfiltNS+1))){
         coslat<-cos(dat$lat[i]*pi/180)
         nfiltEW<-floor(nfiltNS/coslat)+1
         for(j in (nfiltEW+1):(nc-(nfiltEW+1))){
             sub<-grid[(i-nfiltNS):(i+nfiltNS),(j-nfiltEW):(j+nfiltEW)]
             if (is.null(countMat)){
                 grid[i,j]<-mean(sub,na.rm=TRUE)
             }else{
                 count<-countMatt[(i-nfiltNS):(i+nfiltNS),(j-nfiltEW):(j+nfiltEW)]
                 grid[i,j]<-sum(sub*count,na.rm=TRUE)/sum(count,na.rm=TRUE)
             }
         }
       }
       grid[idland]<-land[idland]
   }
   grid[idland]<-NA
   return(list(g=t(grid),lon=dat$lon,lat=dat$lat)) 
}
