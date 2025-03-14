import fontforge

# Open the font
font = fontforge.open('Code128_crs.sfd')

# Set all TrueType export options
font.em = 2048  # Standard TTF em size
font.selection.all()  # Select all glyphs

# Export with options
font.generate('Code128_out2.ttf', flags=[
    'opentype',    # Export OpenType tables
    'round',       # Round coordinates to integers
    'short-post',  # Short PostScript names
    'dummy-dsig',  # Include a dummy DSIG table
    'omit-instructions'  # Remove hinting instructions
])

print("Exported TTF successfully to: Code128_out2.ttf")