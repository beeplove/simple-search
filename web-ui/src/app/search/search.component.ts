import { Component, OnInit } from '@angular/core';

import { SearchService } from '../search.service';

import { Entity } from '../entity';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {
  query:     string = '';
  entityId:  string = '';
  fieldName: string = '';

  entities:  Entity[] = [];
  fields:    string[] = [];

  constructor(
    private searchService: SearchService
  ) { }

  ngOnInit() {
    this.getEntities();
    this.getFields();
  }

  getEntities(): void {
    if (this.entities.length == 0) {
      this.entities.push(new Entity(0, "Any"));
    }

    this.searchService.getEntities()
      .subscribe(response => {
        if ((response.status == 'error') || (this.entities.length > 1)) return;
        for(let i=1; response.data[i.toString()]; i++) {
          this.entities.push(new Entity(i, response.data[i.toString()]));
        }
      });
  }

  getFields(): void {
    this.fields.push('Any');
  }

  getSearchResult(): void {
    if (this.query.length == 0) return;

    this.searchService.getSearchResult(this.query)
      .subscribe(response => {
        if (response.status == 'error') return;

        console.log(response.data);
      });
  }

}
