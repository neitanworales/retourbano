import { HttpHeaders } from "@angular/common/http";
import { Injectable } from "@angular/core";

@Injectable()
export class Utils {

    constructor(
    ) { }

    public getHeaders(): HttpHeaders {
        //const user = JSON.parse(localStorage.getItem('currentUser')!);
        return new HttpHeaders({
            'Content-Type': 'application/json',
            //'Authorization': `Bearer ${user.token}`
        });
    }

}

export type UserRole = 'admin' | 'staff';