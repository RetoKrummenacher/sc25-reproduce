include: "doe.smk"
include: "matrices.smk"

rule all:
  input:
    expand("data/mpi_scale_nodes/{matrix}/{benchmark}/{lang}/{nb_nodes}/{iter}.dat",\
      matrix=MATRICES,\
      benchmark=SCRIPTS_MPI_WITH_MATRICES,\
      lang=["cpp","py","jl"],\
      nb_nodes=MPI_SCALE_NB_NODES,\
      iter=ITERATIONS), 
    expand("data/mpi_scale_nodes/{matrix}/{benchmark}/daph/{scheme}-{layout}-{victim}/{nb_nodes}/{iter}.dat",\
      matrix=MATRICES,\
      benchmark=SCRIPTS_MPI_WITH_MATRICES,\
      scheme=["static"],\
      layout=["centralized"],\
      victim=["seq"],\
      nb_nodes=MPI_SCALE_NB_NODES,\
      iter=ITERATIONS),    

rule run_expe_mpi_jupycpp:
  input:
    sbatch="sbatch_scripts/run_vega_{lang}_mpi.sh",
    script="benchmark_scripts/{benchmark}-mpi/{lang}/{benchmark}.{lang}",
    mtx="matrices/{matrix}/{matrix}_ones.mtx",
    meta="matrices/{matrix}/{matrix}_ones.mtx.meta" 
  output:
    "data/mpi_scale_nodes/{matrix}/{benchmark}/{lang}/{nb_nodes}/{iter}.dat"  
  wildcard_constraints:
    matrix="|".join(matrices.keys()),
    benchmark="|".join(SCRIPTS_MPI_WITH_MATRICES),
    lang="cpp|py|jl"
  params:
    matrix_size = lambda w: matrices[w.matrix]["meta"]["numRows"],
    tasks_per_node = 16,  # MPI process each with 1 thread for cpp, jl and py
    cpus_per_task = 1,
  shell:
    """
    mkdir -p $(dirname {output}) 
    sbatch  --nodes={wildcards.nb_nodes} \
            --ntasks-per-node={params.tasks_per_node} \
            --cpus-per-task={params.cpus_per_task} {input.sbatch} {params.cpus_per_task} {input.script} {input.mtx} {params.matrix_size} {output}
    """

rule run_expe_mpi_daph:
  input:
    sbatch="sbatch_scripts/run_vega_daph_mpi.sh",
    daphne="daphne-src-mpi/bin/daphne",
    script="benchmark_scripts/{benchmark}/daph/{benchmark}.daph",
    mtx="matrices/{matrix}/{matrix}_ones.mtx",
    meta="matrices/{matrix}/{matrix}_ones.mtx.meta"
  output:
    "data/mpi_scale_nodes/{matrix}/{benchmark}/daph/{scheme}-{layout}-{victim}/{nb_nodes}/{iter}.dat" 
  wildcard_constraints:
    matrix="|".join(matrices.keys()),
    benchmark="|".join(SCRIPTS_MPI_WITH_MATRICES),
  params:
    matrix_size = lambda w: matrices[w.matrix]["meta"]["numRows"],
    tasks_per_node = 1,   # 1 process with many threads per process for daphne
    cpus_per_task = 16,
    scheme_uc = lambda w: w.scheme.upper(),
    layout_uc = lambda w: w.layout.upper(),
    victim_uc = lambda w: w.victim.upper(),
    nb_nodes_daph = lambda w: int(w.nb_nodes) + 1 # additonal node for coordinator
  shell:
    """
    mkdir -p $(dirname {output})
    sbatch --nodes={params.nb_nodes_daph} \
            --ntasks-per-node={params.tasks_per_node} \
            --cpus-per-task={params.cpus_per_task} \
             {input.sbatch} {params.cpus_per_task} {input.script} {input.mtx} {params.matrix_size} {params.scheme_uc} {params.layout_uc} {params.victim_uc} {output}
    """

