extends Resource
class_name Universalfunc

#list of functions that are used throughout the code
func testcopy():
    #var original_file = FileAccess.open("res://assets/gamedata.cdb", FileAccess.READ)
    #var file = FileAccess.open("user://gamedata.cdb", FileAccess.WRITE)
    pass
    
func copyDatabase():
    var original_sql_file = FileAccess.open("res://assets/gamedata.cdb", FileAccess.READ)
    var original_sql_file_buffer = original_sql_file.get_buffer(original_sql_file.get_length())
    original_sql_file.close()
    
    var dir = DirAccess.open("user://")
    dir.make_dir("data")
    var new_sql_file = FileAccess.open("user://gamedata.cdb", FileAccess.WRITE)
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
     for sheet in data_cbd["sheets"]:
         if sheet["name"] == sheettype:
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
     if type == 'summon' or type == 'enemySummon':
       base = load("res://scenes/widgets/Summoncard.tscn").instantiate()
       var att = carddict["attack"]
       var hp = carddict["hp"]
       var printedname = carddict["name"]
       var effect = carddict["effect"]
       var description = carddict["description"]
       var counter = carddict["counter"]
    
       base.attack = att
       base.hp = hp
       base.printedname = printedname
       #base.effect = effect
       base.description = description #+ '. ' + createEffectDesc(effect, base.type)
       base.counter = counter
       base.type = "summon"
       
       #specfic code for enemysummons and regular summons
       if type == 'summon':
         var energy = carddict["energy"]
         base.energy = energy
       
       if type == 'enemySummon':
         base.alliance = false
       
       #construct the effect array (only for summons for now)
       var copyEffect = []
       if !effect.is_empty():
         for cardEffect in effect:
           copyEffect.append(createEffect(cardEffect))
       base.effect = copyEffect
    
     elif type == 'spell':
       base = load("res://scenes/widgets/Spellcard.tscn").instantiate()
       var printedname = carddict["name"]
       var energy = carddict["energy"]
       var effect = carddict["effect"]
       var description = carddict["description"]
       
       base.printedname = printedname
       base.effect = effect
       base.energy = energy
       base.description = description #+ '. ' + createEffectDesc(effect, base.type)
       base.type = "spell"
     
     return base

#spawn a generic pop up message to a node
#this function behaves very weirdly, it will not spawn text properly when passing self as a reference
#but does fine with getnode and $node
func genericPopUp(spawnParent, nodepos, textMsg):
    var popLabel = load("res://scenes/widgets/placeholderPopUp.tscn").instantiate()
    popLabel.get_node("Label").text = textMsg
    #center the message on the object
    var centrepos = nodepos.get_global_position()
    popLabel.global_position = centrepos
    spawnParent.add_child(popLabel)
    popLabel.popUp()

#this function copies an array then adds a status/effect to the array, then sets the copied
#array to the previous array, this is made so that setter functions can be activated

#activeArray is the array to be edited, variable adds status if true and removes if false
#statuses can either be a singular enum or an array of enum
func editStatusArray(activeArray : Array, add : bool , statuses , value : int = 0):
    if add:
      var copyArray = activeArray.duplicate()
      
      for status in activeArray:
        if status.statusTypeEnum == statuses:
           status.value += value
           return copyArray
        
      var newEffect = Status.new(statuses, value)
      copyArray.append(newEffect)
      return copyArray

func spawnStatusSymbol(status : Status):
    var symbol = load("res://scenes/widgets/statusSymbol.tscn").instantiate()
    symbol.value = status.value
    match status.statusTypeEnum:
      DataManager.STATUS.sleep:
        symbol.get_node("SymbolArt").texture = load("res://assets/Symbols/sleep.png")
        return symbol
      DataManager.STATUS.poison:
        symbol.get_node("SymbolArt").texture = load("res://assets/Symbols/poison.png")
        return symbol
      DataManager.STATUS.hex:
        symbol.get_node("SymbolArt").texture = load("res://assets/Symbols/hex.png")
        return symbol
      _:
        return symbol
    
func createEffect(effectArray : Dictionary):
    var effectStringToEnum = DataManager.EFFECTS.get(effectArray["effectType"])
    var statusStringToEnum = DataManager.STATUS.get(effectArray["status"])
    
    return Effect.new(effectStringToEnum, statusStringToEnum, effectArray["value"])         

func triggerStatuses(triggeredEnum: DataManager.STATUS, card: BaseCard, altTrigger: bool = true):
      for statusEffect in card.status:
          if statusEffect.statusTypeEnum == triggeredEnum:
              statusEffect.applyStatus(card, altTrigger)
       
func _ready():
    copyDatabase()
