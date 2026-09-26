# Taller — tu primera llamada a OpenRouter

Notebook de la **Clase 05 — OpenRouter**. Le hablamos a un modelo de IA con el
mismo `POST` + JSON de las clases de HTTP y del juego de detectives.

| Notebook | Qué cubre |
|----------|-----------|
| `openrouter.ipynb` | primera llamada, `system` y tono, conversación, parámetros, comparar modelos, salida estructurada, errores |

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

- El notebook usa un modelo `:free` (`meta-llama/llama-3.3-70b-instruct:free`),
  así que no necesitas tarjeta. Las celdas de comparación y de salida
  estructurada usan `openai/gpt-4o-mini`, que es de pago.
- Los model IDs y precios cambian seguido. La lista viva está en
  <https://openrouter.ai/models>. Si un `:free` da `429` o `503`, prueba otro.
- La `.env` está en `.gitignore`. Quien tiene tu key gasta tus créditos: nunca
  la escribas en el notebook ni la subas a git.
