from fontTools.ttLib import TTFont

def modify_font_metadata(input_file, output_file):
    # Open the font file
    font = TTFont(input_file)
    
    # Get the 'name' table where metadata is stored
    name_table = font['name']
    
    # Iterate through the name records and update them if they contain the target word
    for record in name_table.names:
        print(f"Name ID: {record.nameID}")
        print(f"---Value: {record.toUnicode()}")
        
        if record.nameID == 1:
            new_value = "Code128_gjwakker"     
            record.string = new_value.encode('utf-16-be')
            
        if record.nameID == 3:
            new_value = "Code128_gjwakker:Version 3.00"     
            record.string = new_value.encode('utf-16-be')  

        if record.nameID == 4:
            new_value = "Code128_gjwakker"     
            record.string = new_value.encode('utf-16-be')  
            
        if record.nameID == 5:
            new_value = "Version 3.00 March 20, 2025"     
            record.string = new_value.encode('utf-16-be')  

        if record.nameID == 6:
            new_value = "Code128_gjwakker"     
            record.string = new_value.encode('utf-16-be')    

        if record.nameID == 9:
            new_value = "github.com/gjwakker"     
            record.string = new_value.encode('utf-16-be')            

        print(f"NewValue: {record.toUnicode()}")
    # Save the modified font
    font.save(output_file)
    print(f"Font saved as '{output_file}'")

if __name__ == "__main__":
    input_file = "src\Code128.ttf"
    output_file = "build\Code128_gjwakker.ttf"
    target_word = "Code128"
    replacement = "Code128_test"

    modify_font_metadata(input_file, output_file)
