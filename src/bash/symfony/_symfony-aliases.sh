#!/bin/bash

#--------------------------------------------------
# Symfony aliases
#--------------------------------------------------

alias cache='sf cache:clear --env=prod'                            ## Clears the cache
alias router='sf debug:router'                                     ## Debug router
alias schema-update='sf doctrine:schema:update --dump-sql --force' ## Update database shema
alias services='sf debug:container'                                ## Debug container
alias warmup='sf cache:warmup --env=prod'                          ## Warms up an empty cache
