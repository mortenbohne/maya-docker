import maya_docker.get_nodes as get_nodes
from PIL import Image


def test_get_nodes():
    assert len(get_nodes.get_nodes()) > 1

