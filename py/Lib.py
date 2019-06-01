from os import getcwd, mkdir
from os.path import join, dirname
import yaml

def load(file):
    with open(file, 'r') as fd:
        return yaml.load(fd)

def write(file, text):
    with open(file, 'w+') as fd:
        fd.write(text)

def secure_write(file, text):
    mkdir(dirname(file))
    write(file, text)


# Path holder
class Path:
    def __init__(self):
        self.preliminaries=join(getcwd(), "preliminaries")
        self.images=join(getcwd(), "images")
        self.scripts=join(getcwd(), "scripts")
        self.configs=join(getcwd(), "configs")

    def __repr__(self):
        return "Preliminaries: {}\nScripts: {}\nImages: {}\nConfigs: {}". \
        format(self.preliminaries, self.images, self.scripts, self.configs)

# Configuration loader
class Configs:
    def __init__(self, path):
        self.defaults_path = join(path, 'defaults.yml')
        self.defaults = load(self.defaults_path)

    def __repr__(self):
        return "{}: {}".format(self.defaults_path, self.defaults)


# Dockerfile Builder
params = ['DockerFlavor', 'Devices', 'Utils', 'Gui', 'Tools', 'Finalization']
read_param = lambda x : (x['Name'], x['cmd'])
add_sector = lambda x : "\n\n# Sector : {}\n".format(x)
add_comment = lambda x : "#{}\n".format(x)


class Generator:
    def __init__(self, configuration, destination):
        self.config = configuration
        self.destination = join(destination, 'Dockerfile')

    def dump(self):
        Dockerfile = ''
        for sector in params:
            Dockerfile += add_sector(sector)
            for instruction in self.config[sector]:
                name, cmd = read_param(instruction)
                Dockerfile += add_comment(name)
                Dockerfile += cmd
        secure_write(self.destination, Dockerfile)
