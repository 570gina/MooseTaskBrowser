Class {
	#name : #MooseDataSource,
	#superclass : #FTEasyListDataSource,
	#instVars : [
		'format'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #accessing }
MooseDataSource >> cellColumn: column row: rowIndex [
	| cell |
	cell := FTCellMorph new.
	(self elementAt: rowIndex) tasks
		collect: [ :v | self format value: v ]
		thenDo: [ :m | cell addMorphBack: m asMorph ].
	^ cell
]

{ #category : #accessing }
MooseDataSource >> format [
"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	^ format ifNil: [ [ :a | a ] ]
]

{ #category : #accessing }
MooseDataSource >> format: aFormattingBlock [
	"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	format := aFormattingBlock
]

{ #category : #convenience }
MooseDataSource >> selectAll [
	"check with Cyril to move it up the hierarchy"
	self flag: #cyril.
	self setSelectedItems: self elements
]

{ #category : #accessing }
MooseDataSource >> selectedIndexes [
"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	^ table selectedRowIndexes
]

{ #category : #accessing }
MooseDataSource >> selectedItems [
"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	^ table selectedRowIndexes
		collect: [ :index | self elementAt: index ]
]

{ #category : #accessing }
MooseDataSource >> setSelectedIndexes: indexes [
	"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	table selectRowIndexes: indexes
]

{ #category : #accessing }
MooseDataSource >> setSelectedItems: items [
	"check with Cyril to move it up the hierarchy"

	self flag: #cyril.
	table selectRowIndexes: (items collect: [ :i | elements indexOf: i ])
]
