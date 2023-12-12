extends Resource
class_name Universal

#list of functions that are used throughout the code

func copyDatabase():
    var original_sql_file 
    original_sql_file.open("res://assets/gamedata.cdb", FileAccess.READ)
    var original_sql_file_buffer = original_sql_file.get_buffer(original_sql_file.get_length())
    original_sql_file.close()
   
    var new_sql_file
    var dir = DirAccess.open("user")
    dir.make_dir("data")
    new_sql_file.open("user://gamedata.cdb", FileAccess.WRITE)
    new_sql_file.store_buffer(original_sql_file_buffer)
    new_sql_file.close()
    

#read the dataabase
func readDatabase():
     var data_read 
     if OS.get_name() == "HTML5":
        #fix for web versions
        #not save data so it should be ok
        data_read =  FileAccess.open("res://assets/gamedata.cdb", FileAccess.READ)
     else:
        data_read = FileAccess.open("user://gamedata.cdb", FileAccess.READ)
     var test_json_conv = JSON.new()
     test_json_conv.parse(data_read.get_as_text())
     var data_cbd = test_json_conv.get_data()
     data_read.close()
     return data_cbd

#using a for loop, this function will find a card or effect in the database using the id value
#returns a dictionary
func findCard(data_cbd, idvalue, sheettype, targetcolumn):
     var targetentry
     for sheet in data_cbd['sheets']:
         if sheet['name'] == sheettype:
            for entry in sheet["lines"]:
                if entry[targetcolumn] == idvalue:
                   targetentry = entry.duplicate()
     return targetentry

#this function creates a custom description based on the card's effect
#to be called from the card, take the card's type string and effect array
func createEffectDesc(effectlist, type):
     #return empty string if effect array is empty
     if len(effectlist) < 1:
        return ''
    
     var sheetTarget #sheetraget value for finding a effect's description
     var effectdesc = '' #final effect description, to be returned
     var data_cbd = readDatabase() #read database
     if type == 'summon':
        sheetTarget = 'summon_effect_sheet'
     elif type == 'spell':
        sheetTarget = 'spell_effect_sheet'
    
     for effect in effectlist:
         var carddict = findCard(data_cbd, effect['effectID'], sheetTarget, 'effectName')
         var substring = carddict['description']
         #edit the description with the appropriate value
         effectdesc += substring.replace('[...]', str(effect['value'])) + '. '
     return effectdesc

#create a card using the base card, take in a dictionary
func createCard(carddict, type):
     #load all card values into variables
     var base
     #create a base empty card
     if type == 'summon_data':
       base = load("res://scenes/widgets/Basesummoncard.tscn").instantiate()
       var att = carddict["attack"]
       var hp = carddict["hp"]
       var printedname = carddict["printedName"]
       var energy = carddict["energyCost"]
       var effect = carddict["effect"]
       var description = carddict["description"]
    
       base.attack = att
       base.hp = hp
       base.printedname = printedname
       base.effect = effect
       base.energy = energy
       base.description = description + '. ' + createEffectDesc(effect, base.type)
    
     elif type == 'spell_sheet':
       base = load("res://scenes/widgets/Basespellcard.tscn").instantiate()
       var printedname = carddict["printedName"]
       var energy = carddict["energyCost"]
       var effect = carddict["effect"]
       var description = carddict["description"]
       
       base.printedname = printedname
       base.effect = effect
       base.energy = energy
       base.description = description + '. ' + createEffectDesc(effect, base.type)
     
     return base
