from maya_docker.get_nodes import get_nodes


def test_get_nodes():
    assert len(get_nodes()) > 1
