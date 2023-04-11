import maya_docker.get_nodes as get_nodes


def test_get_nodes():
    assert len(get_nodes.get_nodes()) > 1
