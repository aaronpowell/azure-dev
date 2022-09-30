import * as path from 'path';
import * as vscode from 'vscode';
import { AzureDevCliModel } from "./AzureDevCliModel";
import { AzureDevCliServices } from './AzureDevCliServices';
import { WorkspaceResource } from './ResourceGroupsApi';

export class AzureDevCliApplication implements AzureDevCliModel {
    constructor(private readonly resource: WorkspaceResource) {
    }

    getChildren(): AzureDevCliModel[] {
        const applicationConfigurationPath = this.resource.id;
        const applicationDirectory = path.dirname(applicationConfigurationPath);

        return [
            new AzureDevCliServices(applicationDirectory)
        ];
    }

    getTreeItem(): vscode.TreeItem {
        const treeItem = new vscode.TreeItem(this.resource.name, vscode.TreeItemCollapsibleState.Expanded);

        return treeItem;
    }
}