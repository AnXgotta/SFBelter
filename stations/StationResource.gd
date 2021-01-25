extends Resource
class_name Station


enum StationType { UNK, CONTAINER, STORE, REFINEMENT }

export(StationType) var type = StationType.UNK
export(String) var name = ""
export(String) var description = ""
