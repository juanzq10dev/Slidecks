# Taller — darle herramientas al modelo

Notebook de la **Clase 06 — Tools**. El mismo `POST` de OpenRouter, pero ahora
el modelo puede pedir que ejecutes una función tuya y responder con el resultado.

| Notebook | Qué cubre |
|----------|-----------|
| `01-tools.ipynb` | anatomía de un tool, el ciclo pedir/ejecutar/devolver, taller de la fecha, búsqueda web, ejecutar código |

## Configuración

1. Consigue una API key en <https://openrouter.ai/keys> (o usa la que te dé el instructor).
2. Copia `.env.example` a `.env` y pon tu key:

   ```bash
   cp .env.example .env
   ```

3. Instala y abre el notebook:

   ```bash
   uv sync
   uv run jupyter notebook
   ```

   O abre la carpeta en VS Code y selecciona el kernel de `.venv`.

## Notas

- Usa `nvidia/nemotron-3-super-120b-a12b:free`, que soporta tool calling sin tarjeta.
- La búsqueda web es el plugin `web` de OpenRouter (o el sufijo `:online`).
- El tool `ejecutar_python` corre lo que el modelo escriba: úsalo solo en tu
  máquina y revisa antes qué pidió.
- La `.env` está en `.gitignore`. Quien tiene tu key gasta tus créditos.
