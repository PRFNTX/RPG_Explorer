
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var NodeGraph={} #connect nodes to nodes?
var NodeOrders={} #total connections of each node
var ActiveNodes={} #Vector2(x,y):[0,0,1,-1] (open dirs 1:up clockwise), 0=empty, 1=used, -1 = unavailable
var ContentNodes={} #what is on each space
var VisitedNodes={} #Vector2:[Skills]

var PathGraph={} #stores paths to take between them?
#need to make sure this can be used to spawn new nodes
onready var Shrine=load("res://TrailMapArtAssets/Shrine.scn")
onready var Town=load("res://TrailMapArtAssets/Town.scn")
onready var Tower=load("res://TrailMapArtAssets/Tower.scn")
var Map
func _ready():
	Map=self.get_node("Map")
	map_init()
	set_process_input(true)


#9x15
var StartShrine
var CharPos
var Char
var NumTowns
var NumNodes
var MaxOrder
var TotalOrder=0
var orders=[1,1]
#var orders_used=[0]
var orders_used=[]
var orders_open=[]
func map_init():
	randomize()
	CharPos=Vector2(1,9)
	Char=get_node("MapCharacter")
	var ShrinePos=Vector2(1,9)
	get_node("Map").set_cell(ShrinePos.x,ShrinePos.y,4)
	StartShrine=Shrine.instance()
	add_child(StartShrine)
	StartShrine.set_global_pos(get_cell_pos(1,9))
	get_node("MapCharacter").set_global_pos(get_cell_pos(1,9))
	ActiveNodes[Vector2(1,9)]=[0,0,0,-1]
	ContentNodes[Vector2(1,9)]=Shrine
	VisitedNodes[Vector2(1,9)]=["normal"]
	#randomization axes:
		#central vs outer world (1->0)
		#light vs corruption (darkened) (1->0)
		#more later
	var centrality =0.70
	var luminosity = 0.95
	#select a number of cities. 
	NumTowns=int(rand_range(2,4))
	NumNodes=NumTowns*(1+int(rand_range(2,6)))
	TotalOrder=2*(NumNodes-1)
	orders=[1,1]
	
	var temp_orders=[]
	for i in range(0,(NumNodes-2)-(TotalOrder-NumNodes)/2): #subtract an extra 2 for the required end nodes (no loops)
		temp_orders.append(1)
	print(temp_orders)
	
	for j in range(0,(TotalOrder-NumNodes)/2):
		orders.append(2)
		var rnd=int(rand_range(0,temp_orders.size()))
		temp_orders[rnd]+=1
		if temp_orders[rnd]==4:
			temp_orders.remove(rnd)
			orders.append(4)
	for i in temp_orders:
		orders.append(i)
	
	print(orders.size())
	for i in range(0,orders.size()):
		orders_open.append(i)
	#orders_open.remove(0)
	
	print(NumTowns)
	print(NumNodes)
	print(orders)
	print(orders_used)
	print(orders_open)
	
	
	#start danger level low
	#var baseDanger = (1-luminosity)*(1-centrality)
	
	#towns are connected by a single safe road (roads get less safe based on area)
	
	#each path connects exactly 2 points
	#####
	#####
	#Test Step By Step Generation
	NodeOrders[Vector2(1,9)]=0
	
	#CreatePoint(3,9,TileLogic(3,9,1,0.5),Vector2(1,9))
	ActiveNodes[Vector2(1,9)]=[0,0,0,-1]
	Discovery(Vector2(1,9))
	MoveTo(Vector2(1,9))

#New Points

func CreatePoint(x,y,tile,connection):
	#move to MoveTo()
	#Map.set_cell(x,y,tile)
	ActiveNodes[Vector2(x,y)]=[0,0,0,0]
	ConnectPoints(Vector2(x,y),connection,0.5)
	###Move to discovery
	#var ord=SetOrder(x,y)
	#ContentNodes[Vector2(x,y)]="empty"
	
	#orders_used.append(orders_open[ord])
	#orders_open.remove(ord)
	
	#print(str("open: ",orders_open))
	#print(str("used: ",orders_used))
	#assign order from array, refer my index not value (single edit instance)
	#add index to orders used

func SetOrder(x,y):
	print("START SET")
	var ord=int(rand_range(0,orders_open.size()))
	print(ord)
	var maxOrd=CheckAdjacents(Vector2(x,y))
	var deadend=false
	var closeable=false
	if maxOrd==0:
		deadend=true
	#if order =1 check that there exist unexplored nodes with order>1 noes with
	var potential=0
	if orders[orders_open[ord]]==1:
		for i in ActiveNodes.keys():
			print(i)
			if VisitedNodes.keys().find(i)==-1 and not NodeOrders.keys().find(i)==-1 and not i==Vector2(x,y):
				potential+=orders[NodeOrders[i]]-1
	print(str("POT: ",potential))
	if potential==0:
		closeable=true
		if closeable and deadend:
			#give player map, make existing node discoverable, change its order, and add a new point with order 1
			print("PANIC: Map Cannot Continue!!")
		var init=ord
		#while the selected order closes the map, try again until you are back where you started
		var check=0
		
		while (orders[orders_open[ord]]==1 or orders[orders_open[ord]]>maxOrd) and check<20 and orders_open.size()>1:
			
			print(str("loop: ", orders_open))
			print(orders_open.size())
			ord=(ord+1)%orders_open.size()
			print(ord)
			print(str("ORD:" ,ord, "makes: ",orders[orders_open[ord]]))
			if orders[orders_open[ord]]==1:
				print("Closed Failure")
			if orders[orders_open[ord]]>maxOrd:
				print("Burgeoning Fail")
			check+=1
	print(str("order:  ",orders_open[ord]),"XXX end Set at: ", orders[orders_open[ord]])
	NodeOrders[Vector2(x,y)]=orders_open[ord]
	return(ord)
####calcs

func get_cell_pos(x,y):
	var ret=Vector2(16+32*x,12+32*y)
	return ret

func get_current_order():
	var total
	for i in ActiveNodes.keys():
		for j in ActiveNodes[i]:
			if j==1:
				total+=1
	return(total)
###Connections

func ConnectPoints(Pos1,Pos2,danger):
	#if (get_node("Map").get_cell(Pos1.x,Pos1.y)>-1 and get_node("Map").get_cell(Pos2.x,Pos2.y)>-1):
		var dif = (Pos1-Pos2)/2
		print(str("dif",dif))
		if dif.x!=0:
			var temp=ActiveNodes[Pos1]
			temp[int(dif.x+2)%4]=1#check this code, all zeroes
			ActiveNodes[Pos1]=temp
			var temp=ActiveNodes[Pos2]
			temp[(int(dif.x+4))%4]=1
			ActiveNodes[Pos2]=temp
		if dif.y!=0: #moving up/down
			var temp=ActiveNodes[Pos1] #get the connections from the existing point
			temp[int(dif.y+3)%4]=1 #dif.y is -1 moving up, 1 movingdown. +1 -> 0,2 ([up,right,down,left])
			ActiveNodes[Pos1]=temp
			var temp=ActiveNodes[Pos2]
			temp[int((dif.y+1))%4]=1
			ActiveNodes[Pos2]=temp
			print(str("NEW:",ActiveNodes[Pos2]))
		#move to MoveTo()
		#Map.set_cell(Pos1.x-dif.x,Pos1.y-dif.y,TileLogic(Pos1.x,Pos1.y,0,danger,Pos2.x,Pos2.y))
		
func _input(event):
	
	
	if (event.is_action_pressed("Up") and ActiveNodes[CharPos][0]==1):
		print("UP")
		CharPos.y=CharPos.y-2
		Char.set_global_pos(get_cell_pos(CharPos.x,CharPos.y))
		if not VisitedNodes.keys().find(CharPos)>-1:
			MoveTo(CharPos,["normal"])
	elif (event.is_action_pressed("Right") and ActiveNodes[CharPos][1]==1):
		print("Right")
		CharPos.x=CharPos.x+2
		Char.set_global_pos(get_cell_pos(CharPos.x,CharPos.y))
		if not VisitedNodes.keys().find(CharPos)>-1:
			MoveTo(CharPos,["normal"])
	elif (event.is_action_pressed("Down") and ActiveNodes[CharPos][2]==1):
		print("Down")
		CharPos.y=CharPos.y+2
		Char.set_global_pos(get_cell_pos(CharPos.x,CharPos.y))
		if not VisitedNodes.keys().find(CharPos)>-1:
			MoveTo(CharPos,["normal"])
	elif (event.is_action_pressed("Left") and ActiveNodes[CharPos][3]==1):
		print("Left")
		CharPos.x=CharPos.x-2
		Char.set_global_pos(get_cell_pos(CharPos.x,CharPos.y))
		if not VisitedNodes.keys().find(CharPos)>-1:
			MoveTo(CharPos,["normal"])
		

###Some mapping stuff
var AdjDirs=[Vector2(0,-2),Vector2(2,0),Vector2(0,2),Vector2(-2,0)]

func CheckAdjacents(at):
	var adjs=4
	for i in range(0,AdjDirs.size()): #check all directions
		if at.x+AdjDirs[i].x<1 or at.y+AdjDirs[i].y<1 or at.y+AdjDirs[i].y>19 or at.x+AdjDirs[i].x>29 :
			ActiveNodes[at][i]=-1
			adjs-=1
		elif ActiveNodes[at]==[0,0,0,0]:
			print("EMPTY NODE ERROR IN CheckAdjacents()")
		#	if ActiveNodes.keys().find(at+AdjDirs[i])>-1: #for active nodes with no paths to them
		#		ActiveNodes[at][i]=-1 #these routes become impassable
		#		adjs-=1 #the number of open adjacent spaces decreases accordingly
		#		ActiveNodes[at+AdjDirs[i]][(i+2)%4]=-1 #make sure te other node knows this as well
		elif (ActiveNodes.keys().find(at+AdjDirs[i])>-1 and ActiveNodes[at][i]==0):
				ActiveNodes[at][i]=-1 #these routes become impassable
				adjs-=1 #the number of open adjacent spaces decreases accordingly
				ActiveNodes[at+AdjDirs[i]][(i+2)%4]=-1 #make sure te other node knows this as well
	return(adjs)
	
	
####
###
#DIscovery
func Discovery(at,skills=["normal"]): #first time at a new node
	print("START DISCOVERY")
	var maxAdj=CheckAdjacents(at)
	
	
	#[Skills} are the ways the character is able to look for new paths
	#[normal] is the default input
	if VisitedNodes.keys().find(at)==-1:
		var ord=SetOrder(at.x,at.y)
		ContentNodes[Vector2(at.x,at.y)]="empty"
	
		orders_used.append(orders_open[ord])
		orders_open.remove(ord)
	
		print(str("open: ",orders_open))
		print(str("used: ",orders_used))
		#assign order from array, refer my index not value (single edit instance)
		#add index to orders used
		VisitedNodes[at]=[]
		#ConnectPoints(at,at+mod,0.5) #TileLogic(at.x,at.y,0,0.5,(at.x+mod.x),at.y+mod.y)
		VisitedNodes[at].append(skills)#remove doubles 
		var toConnect=orders[NodeOrders[at]]-1
		print(str("ToConnect: ",toConnect))
		if maxAdj<orders[NodeOrders[at]]:
			print("Order Error in discovery!")
		var freedoms=[]
		for i in range(0,ActiveNodes[at].size()):
			if ActiveNodes[at][i]==0:
				freedoms.append(i)
		print(str("freedoms: ", freedoms))
		while toConnect>0:
			var to
			var set
			#favor continuing horizontal on center, and up/ down otherwise
			if at.y==9 and not freedoms.find(1)==-1:
				set=freedoms.find(1)
				to=1
				freedoms.remove(set)
			elif at.y<9 and not freedoms.find(0)==-1:
				set=freedoms.find(0)
				to=0
				freedoms.remove(set)
			elif at.y>9 and not freedoms.find(2)==-1:
				set=freedoms.find(2)
				to=2
				freedoms.remove(set)
			else:
				var rnd=int(rand_range(0,freedoms.size()))
				to=freedoms[rnd]
				freedoms.remove(rnd)
			var dx=AdjDirs[to].x+at.x
			var dy=AdjDirs[to].y+at.y
			CreatePoint(dx,dy,TileLogic(dx,dy,1,0.05),at)
			Discovery(Vector2(dx,dy))
			toConnect=toConnect-1
	#this spot has been visited
	
	print("END DISCOVERY")
	
#use this to reveal paths etc
func MoveTo(at,skills=["normal"]):
	for i in range(0,ActiveNodes[at].size()):
		if ActiveNodes[at][i]==1:
			Map.set_cell(at.x+AdjDirs[i].x,at.y+AdjDirs[i].y, TileLogic(at.x,at.x,1,0.5))
			var dif = (at-Vector2(at.x+AdjDirs[i].x,at.y+AdjDirs[i].y))/2
			Map.set_cell(at.x-dif.x,at.y-dif.y,TileLogic(at.x,at.y,0,0.5,at.x+AdjDirs[i].x,at.y+AdjDirs[i].y))
	
func TileLogic(x,y,type,danger,x2=null,y2=null):
	#type 0 = trail
	#type 1 = node
	var tileIndex=0
	if type==1:
		int(danger)
	elif type==0:
		var dir
		#dir 0=horizontal, dir 1 = vertical
		if (x-x2)!=0:
			dir=0
			tileIndex=int(danger)+6*(1+dir)
		elif (y-y2)!=0:
			dir=1
			tileIndex=int(danger)+6*(1+dir)
	return(tileIndex)