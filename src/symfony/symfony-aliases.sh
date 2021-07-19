#!/bin/bash

#--------------------------------------------------
# Symfony aliases
#--------------------------------------------------

alias cache='sf cache:clear --env=prod'                            ## clears the cache
alias router='sf debug:router'                                     ## debug router
alias schema-update='sf doctrine:schema:update --dump-sql --force' ## update database shema
alias services='sf debug:container'                                ## debug container
alias warmup='sf cache:warmup --env=prod'                          ## warms up an empty cache