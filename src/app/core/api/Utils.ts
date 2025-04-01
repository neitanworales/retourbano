import { HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Session } from "../models/login/Session";
import { Router } from "@angular/router";

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

}

export type UserRole = 'admin' | 'staff';