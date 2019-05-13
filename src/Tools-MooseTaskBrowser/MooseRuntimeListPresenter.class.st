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

{ #category : #accessing }
MooseRuntimeListPresenter >> icon: anItem [
	^ IconicButton new
		target: self model runner;
		actionSelector: #run:withUpdatingBlock:;
		arguments:
			{anItem.
			[ self model: self model ]};
		labelGraphic: anItem icon;
		color: Color transparent;
		helpText: 'Run';
		borderWidth: 0;
		yourself
]

{ #category : #initialization }
MooseRuntimeListPresenter >> initializeWidgets [
	taskRuntimeList := self newTreeTable contextMenu: self menu.
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

{ #category : #initialization }
MooseRuntimeListPresenter >> runner: aRunner runWithUpdatingBlock: aBlock [
	taskRuntimeList
		addColumn:
			(CompositeTableColumn new
				title: 'State';
				addColumn:
					(ImageTableColumn new
						width: 20;
						evaluated: [ :item | 
							IconicButton new
								target: item;
								actionSelector: #runWithUpdatingBlock:;
								arguments:{aBlock};
								labelGraphic: item icon;
								color: Color transparent;
								helpText: 'Run';
								borderWidth: 0;
								yourself ];
						yourself);
				addColumn:
					(StringTableColumn new
						evaluated: #description;
						yourself))
]

{ #category : #accessing }
MooseRuntimeListPresenter >> taskRuntimeList [
	^ taskRuntimeList
]

{ #category : #event }
MooseRuntimeListPresenter >> whenTaskRuntimeListSelectionChanged: aBlock [
taskRuntimeList whenSelectionChangedDo: aBlock
]
