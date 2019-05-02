Class {
	#name : #MooseRuntimeListPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'taskRuntimeList',
		'detailView'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseRuntimeListPresenter class >> defaultSpec [
	^ SpecPanedLayout newVertical
		position: 75 percent;
		add: #taskRuntimeList;
		add: #detailView;yourself
]

{ #category : #'instance creation' }
MooseRuntimeListPresenter class >> open [
	<script>
	self new openWithSpec
]

{ #category : #action }
MooseRuntimeListPresenter >> debugSelectedItem [
	taskRuntimeList selection selectedItem
		ifNotNil: [ taskRuntimeList selection selectedItem error debug ]
]

{ #category : #accessing }
MooseRuntimeListPresenter >> detailView [
^detailView
]

{ #category : #initialization }
MooseRuntimeListPresenter >> initializeWidgets [
	taskRuntimeList := self newTreeTable contextMenu: self menu.
	taskRuntimeList
		addColumn:
			(CompositeTableColumn new
				title: 'State';
				addColumn:
					(ImageTableColumn new
						width: 20;
						evaluated: #icon;
						yourself);
				addColumn:
					(StringTableColumn new
						evaluated: #description;
						yourself)).
	detailView := self newText disable.
	detailView text: 'Detail Display'.
	self focusOrder
		add: taskRuntimeList;
		add: detailView
]

{ #category : #action }
MooseRuntimeListPresenter >> inspectSelectedItem [
	taskRuntimeList selection selectedItem
		ifNotNil: [ taskRuntimeList selection selectedItem inspect ]
]

{ #category : #action }
MooseRuntimeListPresenter >> itemIsError [
	| item |
	item := taskRuntimeList selection selectedItem.
	^ item isNotNil and:[item class = MooseTaskRuntime and: [ item isError ]]
]

{ #category : #initialization }
MooseRuntimeListPresenter >> menu [
	^ self newMenu
		addItem: [ :anItem | 
			anItem
				name: 'Inspect';
				action: [ self inspectSelectedItem ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Debug';
				visibleIf: [ self itemIsError ];
				action: [ self debugSelectedItem ] ]
]

{ #category : #accessing }
MooseRuntimeListPresenter >> taskRuntimeList [
	^ taskRuntimeList
]

{ #category : #event }
MooseRuntimeListPresenter >> whenTaskRuntimeListSelectionChanged: aBlock [
taskRuntimeList whenSelectionChangedDo: aBlock
]
