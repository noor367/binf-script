#!/usr/local/bin/bash
# written 01 November 2022
# additional features are the improved user interface, including error codes, a help command, and printing the program's actions to terminal

###########################################################################################################################################
# HELPER FUNCTIONS ########################################################################################################################
###########################################################################################################################################
# Exits program if no input is given
no_input() {
    echo    $HASH_LINE
    printf '\n\t \t ERROR \n\n'
    printf '\t > Incorrect Input \n'
    printf '\t > No gene search entered \n'
    printf '\t > Enter "./uniTree -help" for extra information \n'
    printf '\n\t \t EXITING... \n\n'
    echo    $HASH_LINE
    exit    1
}

# Provides information about the script and how it is used
help_command() {
    echo    $HASH_LINE
    printf  '\n\t \t HELP PAGE \n\n'
    echo    $HASH_LINE
    printf  '\n\t > uniTree.sh is a bash program designed to complete: \n'
    printf  '\t   1. UniProtKB database search for a gene name, under the conditions'
    printf  '\n\t      of the results being reviewed and of mammalian origin \n'
    printf  '\t   2. Retrieving the search results in a single fasta file format \n'
    printf  '\t   3. Editing fasta sequence headers to only contain species names \n'
    printf  '\t      (Names are numbered if multiple sequences are from the same species)\n'
    printf  '\t   4. Aligning the sequences to create a phylogenic tree \n'
    printf  '\t   5. Removing all files the program created besides the tree \n\n'
    printf  '\t > Syntax for use: ./uniTree.sh geneName \n'
    printf  '\t > where geneName is searched in the UniProtKB database \n\n'
    printf  '\t > Examples of geneName include INS and EGF, e.g. \n'
    printf  '\t > ./uniTree.sh INS \n'
    printf  '\t > The above example would perform a search retrieval for insulin\n'
    printf  '\n\t \t EXITING... \n\n'
    echo    $HASH_LINE
    exit 1
}

# Exits program if the retrieved results are empty
file_empty() {
    printf  '\n\t\t ERROR \n\n'
    printf  '\t > No results \n'
    printf  '\t > Ensure %s exists \n' $INPUT
    printf  '\t > Try again \n\n'
    printf  '\t \t EXITING... \n\n'
    echo    $HASH_LINE
    rm      $INPUT.fasta
    exit    1
}

###########################################################################################################################################
# MAIN ####################################################################################################################################
###########################################################################################################################################
    source ~binftools/setup-env.sh
    INPUT=$1
    HASH_LINE="########################################################################################################################"

# Program exits if no input
    if [[ $INPUT == '' ]]
    then
        no_input

# Help command: additional feature (improvement to the user interface)
# activated by using ./uniTree.sh -help
    elif [[ $INPUT == '-help' ]]
    then 
        help_command
    fi

    URL='https://rest.uniprot.org/uniprotkb/search?query=gene_exact:'$INPUT'(reviewed:true)%20AND%20(taxonomy_id:40674)&format=fasta&'

# Searches the UniProt database for the entered GENE and retrieves all sequences in a INPUT.fasta file
    echo    $HASH_LINE
    printf  '\n\t Searching UniProtKB for %s ...\n\n' $INPUT
    echo    $HASH_LINE

    wget -O $INPUT.fasta -q $URL

    # if the search results are empty, exit program
    [ -s $INPUT.fasta ] || file_empty

    printf  '\n\t > Sequence(s) for %s retrieved\n' $INPUT
    printf  '\t > Stored in %s.fasta \n\n' $INPUT
    echo    $HASH_LINE

# Edits the headers of the fasta sequences to only include the species name
    printf  '\n\t > Editing fasta sequence header(s)... \n'

    # Removes string between > and the species name
    sed     -i 's/>.*OS=/>/g' $INPUT.fasta

    # Removes string between species name and end of the header
    sed     -i 's/OX.*//g' $INPUT.fasta

    # Capitalises the separate words in the species name i.e Homo sapiens becomes Homo Sapiens
    sed     -i 's/\b\(.\)/\u\1/g' $INPUT.fasta

    # Removes space between words in a species name i.e Homo Sapiens becomes HomoSapiens
    sed     -i 's/[[:blank:]]//g' $INPUT.fasta
    
    # Numbers any sequences with the same species name
    touch  TEMP.fasta
    awk    '(/^/ && s[$0]++) {$0=$0""s[$0]}1;' $INPUT.fasta > TEMP.fasta
    mv     -f TEMP.fasta $INPUT.fasta

    printf  '\t > Editing complete \n'
    printf  '\t > Sequence headers will now only contain the species name \n\n'
    echo    $HASH_LINE

# Runs multiple sequence alignment
    printf      '\n\t > Running multiple sequence alignment... \n'
    clustalw    $INPUT.fasta -align > /dev/null
    printf      '\t > Sequences aligned \n\n'

# Builds phylogenic tree for the aligned sequences
    printf      '\t > Building phylogenic tree...\n'
    clustalw    -INFILE=$INPUT.aln -TREE -OUTPUTTREE=phylip > /dev/null
    touch       $INPUT.tree
    mv          $INPUT.ph $INPUT.tree
    printf      '\t > Tree built \n\n'
    echo        $HASH_LINE

# Removes all files created except the tree
    printf  '\n\t > Removing uneccessary files...\n'
    rm      $INPUT.fasta
    rm      $INPUT.aln 
    rm      $INPUT.dnd
    printf  '\t > Files removed\n\n'
    echo    $HASH_LINE

# Program exiting
    printf  '\n\t\t SUCCESS \n\n'
    printf  '\t > Phylogenic tree can be found in %s.tree \n\n' $INPUT
    printf  '\t \t EXITING... \n\n'
    echo    $HASH_LINE

