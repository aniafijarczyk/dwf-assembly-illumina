# dwf-assembly-illumina
Workflow for fungal genome assembly from illumina reads with docker containers

## Installation
### Requirements
- docker
- shell environment
### Building private repositories
```
docker build -t my_bbmap:38.91 ./images/my_bbmap
```
## Running the workflow
### Modifying config.txt
#### Provide input files and other required or optional parameters in config.txt
```
### Input files
PE1="sample1.fq.gz"
PE2="sample2.fq.gz"
SE=
### Adapters
adapters=NexteraPE-PE.fa
...
```
#### Run the runner script
```
sh run_all.sh
```
