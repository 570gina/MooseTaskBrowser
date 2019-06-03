Class {
	#name : #MooseJobRuntimePresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'taskRuntimeList',
		'detailView',
		'menu'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseJobRuntimePresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
	
		add:
			(SpecPanedLayout newVertical
				position: 75 percent;
				add: #taskRuntimeList;
				add: #detailView);
		yourself
]

{ #category : #'instance creation' }
MooseJobRuntimePresenter class >> open [
	<script>
	self new openWithSpec
]

{ #category : #action }
MooseJobRuntimePresenter >> debugSelectedItem [
	taskRuntimeList selection selectedItem
		ifNotNil: [ taskRuntimeList selection selectedItem error debug ]
]

{ #category : #accessing }
MooseJobRuntimePresenter >> detailView [
^detailView
]

{ #category : #accessing }
MooseJobRuntimePresenter >> icon: anItem [
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
MooseJobRuntimePresenter >> initialize [
	self initializeMenu. super initialize
]

{ #category : #initialization }
MooseJobRuntimePresenter >> initializeMenu [
	menu :=self newMenu
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
MooseJobRuntimePresenter >> initializeWidgets [
	taskRuntimeList := self newTreeTable contextMenu: self menu.
	detailView := self newText disable.
	detailView text: 'Detail Display'.
	self focusOrder
		add: taskRuntimeList;
		add: detailView
]

{ #category : #action }
MooseJobRuntimePresenter >> inspectSelectedItem [
	taskRuntimeList selection selectedItem
		ifNotNil: [ taskRuntimeList selection selectedItem inspect ]
]

{ #category : #action }
MooseJobRuntimePresenter >> itemIsError [
	| item |
	item := taskRuntimeList selection selectedItem.
	^ item isNotNil and:[item class = MooseTaskRuntime and: [ item isError ]]
]

{ #category : #accessing }
MooseJobRuntimePresenter >> menu [
	^ menu
]

{ #category : #initialization }
MooseJobRuntimePresenter >> runner: aRunner withUpdatingBlock: aBlock [
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
MooseJobRuntimePresenter >> taskRuntimeList [
	^ taskRuntimeList
]

{ #category : #event }
MooseJobRuntimePresenter >> whenTaskRuntimeListSelectionChanged: aBlock [
taskRuntimeList whenSelectionChangedDo: aBlock
]
