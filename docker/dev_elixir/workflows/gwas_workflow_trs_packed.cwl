{
    "$graph": [
        {
            "class": "CommandLineTool",
            "doc": "create manhattan plot",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biocontainers/gwas-fasp:vv1.0.0_cv1"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 2,
                    "ramMin": 1024,
                    "outdirMin": 1024
                }
            ],
            "inputs": [
                {
                    "id": "#create_plot.cwl/logistic",
                    "type": "File",
                    "inputBinding": {
                        "position": 1
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#create_plot.cwl/manhattan_plot",
                    "type": "File",
                    "outputBinding": {
                        "glob": "*.png"
                    }
                }
            ],
            "baseCommand": [
                "create_plot.sh"
            ],
            "id": "#create_plot.cwl"
        },
        {
            "class": "Workflow",
            "inputs": [
                {
                    "id": "#main/metadata",
                    "type": "File",
                    "doc": "all the metadata"
                },
                {
                    "id": "#main/variants",
                    "type": "File",
                    "doc": "to be gwased"
                }
            ],
            "outputs": [
                {
                    "id": "#main/covariates",
                    "type": "File",
                    "outputSource": "#main/parse_metadata/covariates"
                },
                {
                    "id": "#main/phenotypes",
                    "type": "File",
                    "outputSource": "#main/parse_metadata/phenotypes"
                },
                {
                    "id": "#main/sex",
                    "type": "File",
                    "outputSource": "#main/parse_metadata/sex"
                },
                {
                    "id": "#main/ids",
                    "type": "File",
                    "outputSource": "#main/parse_metadata/ids"
                },
                {
                    "id": "#main/logistic",
                    "type": "File",
                    "outputSource": "#main/run_gwas/logistic"
                },
                {
                    "id": "#main/manhattan_plot",
                    "type": "File",
                    "outputSource": "#main/create_plot/manhattan_plot"
                }
            ],
            "steps": [
                {
                    "id": "#main/parse_metadata",
                    "run": "#parse_metadata.cwl",
                    "in": [
                        {
                            "id": "#main/parse_metadata/metadata",
                            "source": "#main/metadata"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/parse_metadata/covariates"
                        },
                        {
                            "id": "#main/parse_metadata/phenotypes"
                        },
                        {
                            "id": "#main/parse_metadata/sex"
                        },
                        {
                            "id": "#main/parse_metadata/ids"
                        }
                    ]
                },
                {
                    "id": "#main/run_gwas",
                    "run": "#run_gwas.cwl",
                    "in": [
                        {
                            "id": "#main/run_gwas/variants",
                            "source": "#main/variants"
                        },
                        {
                            "id": "#main/run_gwas/ids",
                            "source": "#main/parse_metadata/ids"
                        },
                        {
                            "id": "#main/run_gwas/sex",
                            "source": "#main/parse_metadata/sex"
                        },
                        {
                            "id": "#main/run_gwas/phenotypes",
                            "source": "#main/parse_metadata/phenotypes"
                        },
                        {
                            "id": "#main/run_gwas/covariates",
                            "source": "#main/parse_metadata/covariates"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/run_gwas/logistic"
                        }
                    ]
                },
                {
                    "id": "#main/create_plot",
                    "run": "#create_plot.cwl",
                    "in": [
                        {
                            "id": "#main/create_plot/logistic",
                            "source": "#main/run_gwas/logistic"
                        }
                    ],
                    "out": [
                        {
                            "id": "#main/create_plot/manhattan_plot"
                        }
                    ]
                }
            ],
            "id": "#main"
        },
        {
            "class": "CommandLineTool",
            "doc": "parse metadata",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biocontainers/gwas-fasp:vv1.0.0_cv1"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "ramMin": 1024,
                    "outdirMin": 1024
                }
            ],
            "inputs": [
                {
                    "id": "#parse_metadata.cwl/metadata",
                    "type": "File",
                    "doc": "original content",
                    "inputBinding": {
                        "position": 1
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#parse_metadata.cwl/covariates",
                    "type": "File",
                    "outputBinding": {
                        "glob": "covariates.txt"
                    }
                },
                {
                    "id": "#parse_metadata.cwl/phenotypes",
                    "type": "File",
                    "outputBinding": {
                        "glob": "phenotypes.txt"
                    }
                },
                {
                    "id": "#parse_metadata.cwl/sex",
                    "type": "File",
                    "outputBinding": {
                        "glob": "sex.txt"
                    }
                },
                {
                    "id": "#parse_metadata.cwl/ids",
                    "type": "File",
                    "outputBinding": {
                        "glob": "ids.txt"
                    }
                }
            ],
            "baseCommand": [
                "parse_metadata.sh"
            ],
            "arguments": [
                "-c"
            ],
            "id": "#parse_metadata.cwl"
        },
        {
            "class": "CommandLineTool",
            "doc": "run plink on vcf file",
            "hints": [
                {
                    "class": "DockerRequirement",
                    "dockerPull": "biocontainers/gwas-fasp:vv1.0.0_cv1"
                },
                {
                    "class": "ResourceRequirement",
                    "coresMin": 1,
                    "ramMin": 1024,
                    "outdirMin": 1024
                }
            ],
            "inputs": [
                {
                    "id": "#run_gwas.cwl/variants",
                    "type": "File",
                    "inputBinding": {
                        "position": 1
                    }
                },
                {
                    "id": "#run_gwas.cwl/ids",
                    "type": "File",
                    "inputBinding": {
                        "position": 2
                    }
                },
                {
                    "id": "#run_gwas.cwl/sex",
                    "type": "File",
                    "inputBinding": {
                        "position": 3
                    }
                },
                {
                    "id": "#run_gwas.cwl/phenotypes",
                    "type": "File",
                    "inputBinding": {
                        "position": 4
                    }
                },
                {
                    "id": "#run_gwas.cwl/covariates",
                    "type": "File",
                    "inputBinding": {
                        "position": 5
                    }
                }
            ],
            "outputs": [
                {
                    "id": "#run_gwas.cwl/logistic",
                    "type": "File",
                    "outputBinding": {
                        "glob": "*.assoc.logistic"
                    }
                }
            ],
            "baseCommand": [
                "run_gwas.sh"
            ],
            "id": "#run_gwas.cwl"
        }
    ],
    "cwlVersion": "v1.0"
}