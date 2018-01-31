import { Component, OnInit } from '@angular/core';

import { SearchService } from '../search.service';

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

  constructor(
    private searchService: SearchService
  ) { }

  ngOnInit() {
    this.getEntities();
    this.getFields();
  }

  getEntities(): void {
    this.entities.push(new Entity(0, "Any"));

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
}
