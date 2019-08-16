import { Component, OnInit, OnDestroy } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { map, catchError } from 'rxjs/operators';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit, OnDestroy {
  title;
  subscription = new Subscription();
  constructor(private httpClient: HttpClient) {
  }
  ngOnInit(): void {
    this.subscription.add(this.httpClient.get<string[]>('http://sistema-api-ci.tjmt.jus.br:9090/titles')
      .pipe(map(r => r[0]))
      .pipe(catchError(e => {
        console.error(e);
        throw e;
      }))
      .subscribe(r => {
        console.log('Resposta: ', r);
        this.title = r;
      }));
  }
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
