DAPHNE_GIT_URL    = "https://github.com/daphne-eu/daphne"
# DAPHNE_GIT_COMMIT = "218e4688c132615195e329b2734962b05cd74500" # 0.3
DAPHNE_GIT_COMMIT = "aa1fb14badc0083c2d927210b782745544260f38"
# DAPHNE_DOCKER_TAG = "0.3_X86-64_BASE_ubuntu20.04"
DAPHNE_DOCKER_TAG = "2025-03-12_X86-64_BASE_ubuntu24.04"
JUPYCPP_DOCKER_TAG = "july25"

LANGUAGES = [
  "cpp",
  "py",
  "daph",
  "jl"
]

MATRICES = [
  "amazon0601",
   "wikipedia-20070206",
  #"ljournal-2008"
]

MATRICES_CONFIG = [
  "amazon0601",
  "wikipedia-20070206",
]

SCRIPTS_MPI_WITH_MATRICES = [
  "connected_components",
  #"pagerank",
]

SCRIPTS_WITH_MATRICES = [
  "connected_components",
  # "pagerank",
  #"bfs",
  #"triangle_count"
]

SCRIPTS_WITHOUT_MATRICES = [
  "nbody"
]

NUM_THREADS = [
  1,
  2,
  4,
  8,
  16,
  32,
  64,
  128
]

MPI_LOCAL = {
  # total-mpi-procs, task-per-node, cpu-per-task
  # based on 1  node
  "1":  (1,  1), 
  "2":  (2,  1),
  "4": (4,  1),
  "8": (8,  1),
  "16": (16, 1),
  "32": (32, 1),
  # 64 and 128 could not be run for daphne as memory problems
  # --mem=128 worked for 32 processes, not for 64
  # --mem=256 is the limit of Vega node, and takes ages to start on Vega
  # "64": (64, 1),
  # "128": (128, 1),  
}

# MPI scaling over nodes
MPI_SCALE_NB_NODES = [1,2,3,4,5]

# MPI distributed with many processes on multiple nodes
MPI_NB_NODES=4
# MPI_DISTRIBUTION = {
#   # total-mpi-procs, task-per-node, cpu-per-task
#   # based on MPI_CONFIG_NB_NODES=4 (4 nodes)
#   "4":  (1,  128),
#   "8":  (2,  64),
#   "16": (4,  32),
#   "32": (8,  16),
#   "64": (16, 8),
#   "128": (32, 4),
#   "256": (64, 2),
#   "512": (128, 1)
# }

TOTAL_ITERS = 5
# TOTAL_ITERS = 1  # for testing
ITERATIONS = range(1, TOTAL_ITERS + 1)

SCHEMES = [
  "STATIC",
  "GSS",
  "AUTO",
  "VISS",
  # "SS",
  "TSS",
  "FAC2",
  "TFSS",
  "FISS",
  "PLS",
  "MSTATIC",
  "MFSC",
  "PSS",
]

QUEUE_LAYOUTS = [
  "CENTRALIZED",
  "PERGROUP",
  "PERCPU"
]

VICTIMS = [
  "SEQ",
  "SEQPRI"
]
