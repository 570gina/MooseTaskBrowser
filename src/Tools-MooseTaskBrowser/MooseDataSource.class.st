Class {
	#name : #MooseDataSource,
	#superclass : #FTEasyListDataSource,
	#instVars : [
		'format'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #accessing }
MooseDataSource >> cellColumn: column row: rowIndex [
	^ FTCellMorph new
		addMorphBack: (self format value: (self elementAt: rowIndex)) asMorph;
		yourself
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
MooseDataSource >> selectedItems [
	^ table selectedRowIndexes
		collect: [ :index | self elementAt: index ]
]

{ #category : #accessing }
MooseDataSource >> setSelectedItems: items [
	table selectRowIndexes: (items collect: [ :i | elements indexOf: i ])
]
