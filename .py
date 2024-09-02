class Nodo:
    def __init__(self, estado, padre=None, accion=None):
        self.estado = estado
        self.padre = padre
        self.accion = accion

def dfs(estado_inicial, objetivo):
    stack = [Nodo(estado_inicial)]
    visitados = set()

    while stack:
        nodo_actual = stack.pop()
        
        # Si se llega al estado objetivo, retornar el nodo actual
        if nodo_actual.estado == objetivo:
            return nodo_actual

        # Añadir el estado actual a visitados
        visitados.add(tuple(map(tuple, nodo_actual.estado)))

        # Generar sucesores y añadirlos a la pila (stack)
        for accion, estado_sucesor in sucesores(nodo_actual.estado).items():
            if tuple(map(tuple, estado_sucesor)) not in visitados:
                stack.append(Nodo(estado_sucesor, nodo_actual, accion))

    return None

def reconstruir_camino(nodo):
    camino = []
    while nodo.padre is not None:
        camino.append(nodo.accion)
        nodo = nodo.padre
    camino.reverse()
    return camino
