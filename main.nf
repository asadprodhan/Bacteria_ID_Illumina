#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.read = "$PWD/*.fastq.gz"
params.read1 = "$PWD/*R1_001.fastq.gz"
params.read2 = "$PWD/*R2_001.fastq.gz"

params.outdir = './results'
		

process fastqc {

	publishDir "${params.outdir}", mode:'copy' 	

	input:
		val read 	 				

	output:
		stdout  
        	
	script:
	"""
	fastqc $read 
	
	"""
}

process spades {
			
	publishDir "${params.outdir}", mode:'copy' 	

	input:
		tuple path (read1),path(read2) 				

	output:
		stdout emit: results
		path '*', emit: output
        	
	script:
	"""
	spades.py -1 ${read1} -2 ${read2} --careful --cov-cutoff auto -o spades_assm

	"""
}

workflow {   
	fastqc(
		Channel.fromPath(params.read)
	)
	spades(
		Channel.of([file(params.read1), file (params.read2)]))	
       
}