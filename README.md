# ERGM-Helper-Code
Helper Functions when running ERGMs

Bulk ERGM Fit.R:
This examines every single combination of terms you think would be relevant to a particular network in fitting an ERGM and fits all of those terms. It's meant to be used as a preliminary model fitting function to identify candidate models for further analysis. It is not meant to automate model exploration. The purpose behind the AIC threshold is to weed out ERG models that are degenerate but are not identified as being degenerate under the ERGM package. ERGM will prematurely terminate if it determines it's fitting a bad model, which is why the try function is included. If you want to look at all models regardless of how terrible the AIC is, set AIC Threshold to Inf. And against all odds, I provide this to you for free.
