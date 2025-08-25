# Seamless Scaling of Applications Across Programming Models

The following is a description of artifacts for the poster under review 'Seamless Scaling of Applications Across Programming Models'.

## Structure of the repository

### Hardware information 
[collect_environment.txt](collect_environment.txt) contains detailed hardware information collected with [collect_environment.sh](collect_environment.sh)

### [Conda Environments](conda_envs)

- [`snakemake.yml`](conda_envs/snakemake.yml)
- [`code_metrics.yml`](conda_envs/code_metrics.yml)
- [`plotting.yml`](conda_envs/plotting.yml)

To use them on Vega:  
```console
module load Anaconda
conda env create -f snakemake.yml
conda activate snakemake
```

### [Benchmark Scripts](benchmark_scripts)

Each of the folder contains the code for the sequential/parallel (SePa) and distributed (`-mpi`, Dist) versions of the GAP Benchmark.

In each benchmark folder, there is one folder per language (`cpp`, `daph`, `jl`, `py`), note that that there is no `daph` folder for the `mpi` version as the mpi version is the same as the sequential one.

### [Sbatch Scripts](sbatch_scripts)

This folder contains the `sbatch` scripts used to execute the different languages in the different context (sequential and parallel, distributed).

The interface is as follow:

1. For local parallel:
```console
sbatch ./sbatch_scripts/run_vega_{LANG}.sh {NUM_THREADS} {SRC_FILE_PATH} {MATRIX_PATH} {MATRIX_SIZE} {OUTPUT_FILE}
```
2. For distributed with MPI:
```console
sbatch ./sbatch_scripts/run_vega_{LANG}_mpi.sh {NUM_THREADS} {SRC_FILE_PATH} {MATRIX_PATH} {MATRIX_SIZE} {OUTPUT_FILE}
```

where:
- `{LANG}` is the language short name (`cpp`, `daph`, `jl`, `py`)

- `{NUM_THREADS}` is the number of threads to use.

- `{SRC_FILE_PATH}` is the path to the source code file containing the benchmark

- `{MATRIX_PATH}` is the path to the `.mtx` file

- `{MATRIX_SIZE}` is the size of the matrix (i.e., the number of columns or rows (as we consider only square matrices, those are the same))

- `{OUTPUT_FILE}` is the path where to store the result of the execution

### [Workflow](workflow)

This folder contains the heavy lifting of the experiments.

The workflow is managed by [Snakemake](https://snakemake.readthedocs.io/en/stable/). On Vega, you can execute `Snakemake` from the provided [Conda](https://anaconda.org/anaconda/conda) environment [`snakemake.yml`](conda_envs/snakemake.yml):

#### `.smk` files

- `matrices.smk`: contains the information about the matrices used in the experiments (i.e., where to download, and some metadata)

  - The rules of this file download and decompress the matrices, then set up the metadata file (`.mtx.meta`) and fix the `.mtx` file so that all the linear algebra libraries used in the experiments read the matrices the same way.

- `doe.smk`: file containing the configuration about the **D**esign **O**f **E**xperiments. This is where to change the important parameters. Most of the others `.smk` files read this file.

- `build.smk`: file containing the steps to build DAPHNE (download source code (commit in `doe.smk`), download singularity image, and compile)

- `experiments.smk`: file containing the rules for an experiment comparing the scaling ability of threads on a single node.

- `experiments_mpi_local.smk`: file containing the rules for an experiment comparing the scaling ability of `mpi` processes on a single node.

- `experiments_mpi_scale_nodes.smk`: file containing the rules for an experiment comparing the scaling ability of `mpi` processes on a multiple node.

#### Snakemake 101

**All the Snakemake commands are to be ran from the root of the repository**

To dry-run a workflow:

```console
snakemake -s {WORKFLOW_FILE}.smk -n
```

To execute a workflow with 2 parallel processes and other important flags:

- `--cores`: run workflow with parallel processes

- `--jobs`: run workflow bt submitting this many jobs at a time

- `--latency-wait`: as the data will be written on the NFS it is good practice to tell Snakemake that there might be some latency in the filesystem:

- `--keep-going`: continue to execute the workflow even if one job failed.

- `--rerun-incomplete`: rerun jobs that have been stopped in a weird state before.

```console
snakemake -s {WORKFLOW_FILE}.smk --cores 2 --jobs 20 --latency-wait 60 --keep-going --rerun-incomplete
```

Tell Snakemake to check what output files are already existing to avoid repetition of experiment if not needed:

```console
snakemake -s {WORKFLOW_FILE}.smk --touch --rerun-incomplete
```

### [Data](data)
This folder contains all experimental results.

- [`Sequential and local parallel`](data/seq-local/)
- [`Local MPI`](data/mpi_local/)
- [`MPI on multiple nodes`](data/mpi_scale_nodes/)

The `.dat` files contain the end-to-end and the computation time together with the algorithm result for correctness check:  
`/{MATRIX}/{BENCHMARK}/{LANG}/{PARALLELISM}/{REP}.dat`

where:
- `{MATRIX}` is the input matrix either `amazon0601` or `wikipedia-20070206`

- `{BENCHMARK}` is `connected_components`

- `{LANG}` is the language short name (`cpp`, `daph`, `jl`, `py`)

- `{PARALLELISM}` is the number of threads, mpi processes, or nodes used

- `{REP}` is the repetition of each experiments

### [`Plots`](plots)
The Jupyter notebook `plots.ipynb` that creates the plots from the results and the final [plots](plots/performance/). To have all dependencies, execute the notebook from [plotting.yml](conda_envs/plotting.yml)

### [Coding Productivity](coding_productivity)

- The adapted version of [`multimetric`](coding_productivity/multimetric/) [1] which includes language support for DaphneDSL and collects the source lines of code (SLOC).
- The collected [metrics](coding_productivity/metrics/) in `.json` format.

Execute `multimetric` with the provided [code_metrics.yml](conda_envs/code_metrics.yml) with:

```
 multimetric  input.cpp > output.json
```


## References
[1] Konrad Weihmann. multimetric. Version 2.2.2. Accessed July 10, 2025. 2025. [https://github.com/priv-kweihmann/multimetric](https://github.com/priv-kweihmann/multimetric).



