# PosterAgent

PosterAgent is a multi-agent, layout-aware system for automatic **e-commerce poster generation**.  
Given a structured product record (CSV / JSON / Excel) and a small set of product images, PosterAgent:

1. Parses and normalizes product metadata  
2. Selects and prepares visual assets  
3. Decides color, fonts, and background style  
4. Composes prompts and generates a background image  
5. Solves a simple layout optimization problem  
6. Renders an **editable PPTX** poster

## Repository Structure

posteragent/
  agents/
    parser_agent.py
    curator_agent.py
    aesthetics_agent.py
    scene_composer.py
    layout_agent.py
    renderer.py
  core/
    schema.py          # Canonical product JSON schema
    layout_utils.py    # Bounding-box utilities and overlap checks
    pptx_utils.py      # Helpers for PPTX export
  configs/
    demo.yaml          # Example configuration
  examples/
    products/
      sku_001.json     # Example product record
    assets/
      sku_001/         # Example images (product, logo, etc.)
  scripts/
    run_posteragent.py # Main entry point
    visualize_layout.py
  README.md
  requirements.txt
