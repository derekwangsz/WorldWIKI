//
//  ViewController.swift
//  WorldWIKI
//
//  Created by Derek Wang on 2021-02-24.
//

import UIKit


class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    
    var countries : [String]!
    var filteredCountries : [String]!
    var selectedCountry : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        if let filePath = Bundle.main.path(forResource: "countries", ofType: "txt") {
            do{
                let countriesString = try String(contentsOfFile: filePath)
                countries = countriesString.components(separatedBy: "\n")
                filteredCountries = countries
            }
            catch{
                print("error: \(error)")
            }
        }
        
    }
        
    //MARK: - tableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.textLabel?.text = filteredCountries[indexPath.row]
        return cell
    }
    
    //MARK: - tableView Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedCountry = cell?.textLabel?.text
        performSegue(withIdentifier: "toDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.selectedCountry = selectedCountry
    }
    
    
    //MARK: - Search Bar delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredCountries = countries.filter({ (country) -> Bool in
                return country.contains(searchText)})
        } else {
            searchBar.resignFirstResponder()
            filteredCountries = countries
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
