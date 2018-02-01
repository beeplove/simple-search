import { Component, OnInit } from '@angular/core';

import { SearchService } from '../search.service';

import { Entity } from '../entity';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {
  query:       string = '';
  entityId:    string = '';
  entityName:  string = '';
  fieldName:   string = '';

  entities:    Entity[] = [];
  fields:      string[] = [];

  fieldsFor    = {};
  entityNames  = {};
  searchResult = {};

  constructor(
    private searchService: SearchService
  ) { }

  ngOnInit() {
    this.initEntities();
  }

  initEntities(): void {
    if (this.entities.length == 0) {
      this.entities.push(new Entity(0, "any"));
    }

    this.searchService.getEntities()
      .subscribe(response => {
        if ((response.status == 'error') || (this.entities.length > 1)) return;

        this.entityNames =response.data;
        this.entityNames["0"] = "any";
        for(let i=1; this.entityNames[i.toString()]; i++) {
          this.entities.push(new Entity(i, this.entityNames[i.toString()]));
        }
        this.initFields();
      });
  }

  initFields(): void {
    for (let entity of this.entities) {
      if (entity.id == 0) continue;

      this.searchService.getFields(entity.id)
        .subscribe(response => {
          if (response.status == 'error') return;

          this.fieldsFor[entity.name] = response.data;
          for (let field of response.data) {
            if (this.fields.indexOf(field) < 0) {
              this.fields.push(field);
            }
          }
        });
    }
    this.fieldsFor['any'] = this.fields;
  }

  getSearchResult(): void {
    if (this.query.length == 0) return;

    let entityName = this.entityName == 'any' ? '' : this.entityName;

    this.searchService.getSearchResult(this.query, entityName, this.fieldName)
      .subscribe(response => {
        if (response.status == 'error') return;

        this.searchResult = response.data;
      });
  }

  onChangeEnity(): void {
    this.entityName = this.entityNames[this.entityId];
    this.fields = this.fieldsFor[this.entityNames[this.entityId]];
  }

}
