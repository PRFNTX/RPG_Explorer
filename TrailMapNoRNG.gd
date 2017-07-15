
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var MapGraph={} #tracks connections
var MapTypes={} #tracks Whats where
var MapDanger={} #tracks danger levels
var MapRaw={} # exactly the time map
var mapRead=File.new()


#NEED STEP BY STEP STATE UPDATES
var ProgMapgraph={}
var ProgMapTypes={}
var ProgMapDanger={}
var ProgMapRaw={}
#nodes: ODD
	#x=1,29 
	#y=1, 17
func _ready():
	MapRawMake()

func MapRawParse():
	get_node("Map").set_cell(-1,-1,MapRaw[Vector2(-1,-1)])
	for x in range(1,30):
		for y in range(1,18):
			
			get_node("Map").set_cell(x,y,MapRaw[Vector2(x,y)])
	MapRawMake()

func MapRawMake():
	#parse the raw map into convenient data
	MapRaw[Vector2(-1,-1)]=get_node("Map").get_cell(-1,-1)
	for x in range(1,30):
		for y in range(1,18):
			MapGraph[Vector2(x,y)]=[0,0,0,0]
	for x in range(1,30):
		for y in range(1,18):
			
			MapRaw[Vector2(x,y)]=get_node("Map").get_cell(x,y)
			#Map Types:
				#0=trail
				#1=node
				#2+ = locations unique ID
			if MapRaw[Vector2(x,y)]>-1:
				
				if MapRaw[Vector2(x,y)]<6:
					MapTypes[Vector2(x,y)]=1
				elif MapRaw[Vector2(x,y)]<18:
					MapTypes[Vector2(x,y)]=0
				if MapRaw[Vector2(x,y)]<18:
					MapDanger[Vector2(x,y)]=MapRaw[Vector2(x,y)]%6
				else:
					MapDanger[Vector2(x,y)]=77
				if x%2==0 or y%2==0:
					var vert
					print(str(x,",",y))
					if MapRaw[Vector2(x,y)]<12:
						#horiz
						MapGraph[Vector2(x-1,y)][1]=1
						MapGraph[Vector2(x+1,y)][3]=1
					else:
						#vert
						MapGraph[Vector2(x,y-1)][2]=1
						MapGraph[Vector2(x,y+1)][0]=1
				

func _on_MapSave_pressed():
	for i in MapRaw.keys():
		print(str(i,": ",MapRaw[i]))
	if not get_node("Name").get_text()=="":
		var name=get_node("Name").get_text()
		if name.is_valid_identifier():
			mapRead.open(str("res://Saves/",name,"_Raw.txt"),2)
			mapRead.close()
			mapRead.open(str("res://Saves/",name,"_Raw.txt"),3)
			print(mapRead.is_open())
			#for i in MapGraph.keys():
			mapRead.store_var(MapRaw)
			mapRead.close()
			#mapRead.open(str(name,"_Types"),3)
			#for i in MapGraph.keys():
		#		mapRead.store_var([i].append(MapTypes[i]))
			#map_read.close()
			#mapRead.open(str(name,"_Danger"),3)
			#for i in MapGraph.keys():
		#		mapRead.store_var([i].append(MapDanger[i]))
			#mapRead.close()
			#open file
			#write map vars
			
		else:
			#do not do that
			pass

func _on_MapLoad_pressed():
	if not get_node("Name_Load").get_text()=="":
		var name=get_node("Name_Load").get_text()
		if name.is_valid_identifier() and mapRead.file_exists(str("res://saves/",name,"_Raw.txt")):
			mapRead.open(str("res:///saves/",name,"_Raw.txt"),1)
			#for i in MapGraph.keys():
			MapRaw=mapRead.get_var()
			print("RAWR")
			print(MapRaw.keys())
			mapRead.close()
			
			MapRawParse()
			#mapRead.open(str(name,"_Types"),1)
			#for i in MapGraph.keys():
			#	mapRead.store_var([i].append(MapTypes[i]))
			#mapRead.close()
			#mapRead.open(str(name,"_Danger"),1)
			#for i in MapGraph.keys():
			#	mapRead.store_var([i].append(MapDanger[i]))
			#mapRead.close()
			#open file
			#write map vars
			
		else:
			#do not do that
			pass
