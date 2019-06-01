#! /usr/bin/python3
from Lib import *

# Load path
path = Path()

# Load Configurations
configs = Configs(path.configs)

# Generate DockerFile
gen = Generator(configs.defaults, join(path.images, 'gpu/0.1.0'))
gen.dump()
