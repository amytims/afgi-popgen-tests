# afgi-popgen-tests

Code for testing short read qc, reference mapping and variant calling workflows on Pawsey using AFGI data

1. QC raw data (`fastQC`); Aggregate QC reports (`multiQC`)
2. Trimming and adapter removal (`Trimmomatic`)
3. QC processed data (`fastQC`); Aggregate new QC reports (`multiQC`)
4. merge read lanes
5. Download and index reference genome (`bwa`)

