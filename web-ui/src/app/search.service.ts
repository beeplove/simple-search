import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/Observable';
import { catchError, tap } from 'rxjs/operators';
import { of } from 'rxjs/observable/of';


@Injectable()
export class SearchService {
  private entitiesUrl: string = 'http://localhost:3000/entities';
  private searchUrl:   string = 'http://localhost:3000/search';

  constructor(
    private http: HttpClient
  ) { }

  getEntities(): Observable<any> {
    return this.http.get<any>(this.entitiesUrl)
      .pipe(
        tap(response => { this.log('fetched GET /entities with status `' + response.status + '`' )}),
        catchError(this.handleError('getEntities', {}))
      );
  }

  getSearchResult(query, entityName): Observable<any> {
    let params = {};

    if (query) params['q'] = query;
    if (entityName) params['e'] = entityName;

    return this.http.get<any>(this.searchUrl, { params: params })
      .pipe(
        tap(response => { this.log('fetched GET /search with status `' + response.status + '`' )}),
        catchError(this.handleError('getSearchResult', {}))
      );
  }

  /** to abstract logging */
  private log(message: string) {
    console.log('>> SearchService: ' + message);
  }

  /**
   * Handle Http operation that failed.
   * Let the app continue.
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   */
  private handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {

      // TODO: send the error to remote logging infrastructure
      console.error(error); // log to console instead

      // TODO: better job of transforming error for user consumption
      this.log(`${operation} failed: ${error.message}`);

      // Let the app keep running by returning an empty result.
      return of(result as T);
    };
  }

}
