# # Select ANOVA function V1
# 
# data = growth.df
# cleanreplicates = TRUE
# 
# 
# # First we describe the experiment with a variety of tests derrived from the  vascr_test suite
# 
# design = vascr_test_design(data)
# 
# # Setup the data structures required
# 
# if(design$balanced_samples) # Check if sample design is balanced
# {
# 
#   if(design$balanced_replicates)
#   {
# 
#     return("Balanced Replicates Two Way ANOVA")
#     
#   }
#   else
#   {
# 
#     if(cleanreplicates == TRUE) # If needed, we remove unbalanced samples
#     {
#       removalvector = as.vector(design$unbalanced_replicates["Sample"])
#       subsetdata = vascr_subset(growth.df, sample = removalvector$Sample)
# 
#       print("Replicates cleaned: ")
#       replicateshr = paste(removalvector$Sample, collapse = " , ")
#       replicateshr = paste ("Replicates cleaned: ", replicateshr)
#       print(replicateshr)
#     }
# 
#   }
# 
# } else  # Design is not balanced
# {
#   
#   
# }
# 
# 
