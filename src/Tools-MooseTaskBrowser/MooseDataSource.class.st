Class {
	#name : #MooseDataSource,
	#superclass : #FTEasyListDataSource,
	#instVars : [
		'format'
	],
	#category : #'Tools-MooseTaskBrowser-core-ui'
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
	^ format ifNil: [ [ :a | a ] ]
]

{ #category : #accessing }
MooseDataSource >> format: aFormattingBlock [
	format := aFormattingBlock
]

{ #category : #convenience }
MooseDataSource >> selectAll [
	self setSelectedItems: self elements 
]

{ #category : #accessing }
MooseDataSource >> selectedIndexes [
	^ table selectedRowIndexes
	
]

{ #category : #accessing }
MooseDataSource >> selectedItems [
	^ table selectedRowIndexes
		collect: [ :index | self elementAt: index ]
]

{ #category : #accessing }
MooseDataSource >> setSelectedIndexes: indexes [
	table selectRowIndexes: indexes.
]

{ #category : #accessing }
MooseDataSource >> setSelectedItems: items [
	table selectRowIndexes: (items collect: [ :i | elements indexOf: i ]).
	
]
