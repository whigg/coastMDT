% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getTGCoast.R
\name{getTGCoast}
\alias{getTGCoast}
\title{Helper function to getLandVal: Identify Coast lines with tide gauges}
\usage{
getTGCoast(polyCoast, TG, lonlim, latlim)
}
\arguments{
\item{polyCoast}{Matrix[lon,lat], the out put of the function polygonizeCoast. The matrix contains the coastlines of the region defined by lonlim and latlim, where the integer values represents the coast id.}

\item{TG}{Data frame or matrix with tide gauge information. TG should contain at least the columns with the names 'Longitude', 'Latitude', and 'TGMDT'. 'TGMDT' should contain MDT values at the tide gauge positions.}

\item{lonlim}{Vector of length 2 with the longitude data grid limits, c(lonlim[1],lonlim[2]). The limits must be given in whole degrees.}

\item{latlim}{Vector of length 2 with the longitude data grid limits, c(lonlim[1],lonlim[2]). The limits must be given in whole degrees}
}
\value{
Vector with coast id for the tide gauges.
}
\description{
Helper function to getLandVal: Identify Coast lines with tide gauges
}
\details{
...
}
