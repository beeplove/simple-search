import { Component, OnInit } from '@angular/core';

import { SearchService } from '../search.service';

import { Entity } from '../entity';
import { Organization } from '../organization';
import { Ticket } from '../ticket';
import { User } from '../user';

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
  error        = {};

  searchResultCount: number;

  organizations: Array<Organization>;
  tickets: Array<Ticket>;
  users: Array<User>;

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
    this.fieldsFor = {
      any: []
    };

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

            if (this.fieldsFor['any'].indexOf(field) < 0) {
              this.fieldsFor['any'].push(field)
            }
          }
        });
    }
  }

  getSearchResult(): void {
    let entityName = this.entityName.toLowerCase() == 'any' ? '' : this.entityName;
    let fieldName = this.fieldName.toLowerCase() == 'any' ? '' : this.fieldName;

    this.searchService.getSearchResult(this.query, entityName, fieldName)
      .subscribe(response => {
        if (response.status == 'error') return;

        this.searchResult = response.data;

        this.organizations = response.data.organizations;
        this.tickets = response.data.tickets;
        this.users = response.data.users;

        this.getSearchResultCount();
      });
  }

  getSearchResultCount(): void {
    this.searchResultCount = 0;
    this.searchResultCount += this.organizations ? this.organizations.length : 0;
    this.searchResultCount += this.tickets ? this.tickets.length : 0;
    this.searchResultCount += this.users ? this.users.length : 0;
  }

  onChangeEnity(): void {
    this.entityName = this.entityNames[this.entityId];
    let fields = this.fieldsFor[this.entityNames[this.entityId]];
    if ((fields) && (fields.indexOf('Any')) < 0) {
      fields = ['Any'].concat(fields);
    }
    this.fields = fields;
  }

  onChangeQuery(): void {
    if (this.query.length > 0) this.error['query'] = false;
  }

  onClickSubmit(): void {
    this.error['query'] = false;
    this.searchResultCount = undefined;

    if (this.query.length == 0) {
      this.error['query'] = true;
      return;
    }

    this.getSearchResult();
  }

  onKeyDownQuery(event): void {
    if (event.keyCode == 13) {
      this.getSearchResult();
    }
  }
}
