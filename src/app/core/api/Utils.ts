import { HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Session } from "../models/login/Session";
import { Router } from "@angular/router";
import { environment } from "src/environments/environment";

@Injectable()
export class Utils {

    constructor(
        private router: Router
    ) { }

    public getHeaders(): HttpHeaders {
        //const user = JSON.parse(localStorage.getItem('currentUser')!);
        return new HttpHeaders({
            'Content-Type': 'application/json',
            //'Authorization': `Bearer ${user.token}`
        });
    }

    public getSessionFromStorage(): Session | undefined {
        console.log(localStorage.getItem('session'));
        if (localStorage.getItem('session') == null) {
            console.log("redireccionará");
            this.router.navigate(["/login"]);
            return undefined;
        } else {
            return JSON.parse(localStorage.getItem('session')!);
        }
    }

    public v1(path: string): string {
        const base = (environment.apiUrl || '').replace(/\/+$/, '');
        return `${base}${path}`;
    }
}

export type UserRole = 'admin' | 'staff' | 'super';