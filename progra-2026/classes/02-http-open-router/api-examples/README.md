# Ejemplos de APIs

Notebooks cortos para practicar peticiones HTTP y lectura de JSON contra APIs
públicas reales.

| Notebook | API | ¿API key? |
|----------|-----|-----------|
| `01-poke-api.ipynb` | [PokeAPI](https://pokeapi.co) — Pokémon | No |
| `02-rick-and-morty.ipynb` | [Rick and Morty API](https://rickandmortyapi.com) — personajes, episodios | No |
| `03-nasa-api.ipynb` | [NASA API](https://api.nasa.gov) — foto del día, asteroides | Sí (`DEMO_KEY` para probar) |
| `04-country-api.ipynb` | [countries.dev](https://countries.dev) — datos de países | No |

Todos usan el mismo ayudante `show(respuesta)` para imprimir la respuesta de
forma legible.

## Cómo correrlos

```bash
cd api-examples
uv sync
uv run jupyter notebook
```

O abre la carpeta en VS Code y selecciona el kernel de `.venv`.
