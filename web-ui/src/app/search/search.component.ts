import { Component, OnInit } from '@angular/core';

import { Entity } from '../entity';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {
  entityId: string = '';
  entities: Entity[] = [];

  fieldName: string = '';
  fields: string[] = [];

  constructor() { }

  ngOnInit() {
    this.getEntities();
    this.getFields();
  }

  getEntities(): void {
    this.entities.push(new Entity(0, "Any"))
    this.entities.push(new Entity(1, "organizations"))
    this.entities.push(new Entity(2, "users"))
    this.entities.push(new Entity(3, "tickets"))
  }

  getFields(): void {
    this.fields.push('Any');
  }
}
