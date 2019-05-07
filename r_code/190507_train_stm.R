##### Description #####

# Run topic model. This code is written for Canada 
# but is easily adaptable to US, just load in the respective corpus

############ LIBRARIES ############

library(stm)

#### Implementation ######


can_corpus_file = "my_can_corpus_file.RData" # replace with your own
out_model_object_name = "my_out_model_object.RData" # replace with your own



load(can_corpus_file) # load in corpus as "out" object

interaction_content_spec <- stm(out$documents, out$vocab, K = 20,
                                content = ~ speakerparty, prevalence = ~speakerparty*speechdate, 
                                max.em.its = 200, gamma.prior='L1',
                                data = out$meta, init.type = "Spectral",
                                emtol = 1e-05)

save(interaction_content_spec, file = out_model_object_name)